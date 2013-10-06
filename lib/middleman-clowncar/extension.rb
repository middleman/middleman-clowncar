module Middleman
  class ClownCarExtension < ::Middleman::Extension

    SVG_TEMPLATE = "<svg viewBox='0 0 ::width:: ::height::' preserveAspectRatio='xMidYMid meet' xmlns='http://www.w3.org/2000/svg'><style>svg{background-size:100% 100%;background-repeat:no-repeat;}::media_queries::</style></svg>"

    def initialize(app, options_hash={})
      super

      require 'uri'
      require 'pathname'
      require File.join(File.dirname(__FILE__), 'fastimage')

      @svg_files_to_generate = []

      @ready = false

      app.send :include, ClownCarConfigAPI
    end

    def after_configuration
      @ready = true
    end

    def is_relative_url?(path)
      begin
        uri = URI(path)
      rescue URI::InvalidURIError
        # Nothing we can do with it, it's not really a URI
        return false
      end

      !uri.host
    end

    def get_image_path(name, path, is_relative, fallback_host)
      begin
        uri = URI(path)
      rescue URI::InvalidURIError
        # Nothing we can do with it, it's not really a URI
        return path
      end

      if uri.host
        path
      else
        svg_path = File.join(name, path)

        if is_relative
          url = app.asset_path(:images, svg_path)

          if fallback_host &&is_relative_url?(url)
            File.join(fallback_host, url)
          else
            url
          end
        else
          svg_path
        end
      end
    end

    def generate_media_queries(name, sizes, is_relative, fallback_host)
      output = []

      if sizes.keys.length === 1
        return "svg{background-image:url(#{get_image_path(name, sizes[sizes.keys.first], is_relative, fallback_host)});}"
      end

      previous_key = nil
      sizes.keys.sort.each_with_index do |key, i|
        line = ["@media screen and "]

        if i == 0
          line << "(max-width:#{key}px)"
        elsif i == (sizes.keys.length - 1)
          line << "(min-width:#{previous_key+1}px)"
        else
          line << "(min-width:#{previous_key+1}px) and (max-width:#{key}px)"
        end

        line << "{svg{background-image:url(#{get_image_path(name, sizes[key], is_relative, fallback_host)});}}"

        output << line.join("")
        previous_key = key
      end

      output.join("")
    end

    def get_image_sizes(name, options)
      p = Pathname(app.source_dir) + Pathname(File.join(app.images_dir, name.to_s))

      return {} unless p.exist?

      width = nil
      height = nil

      sizes = p.children.inject({}) do |sum, path|
        begin
          width, height = ::FastImage.size(path.to_s, :raise_on_failure => true)
          rel_path = path.relative_path_from(p).to_s

          unless rel_path === options[:fallback]
            sum[width] = path.relative_path_from(p).to_s
          end
        rescue FastImage::UnknownImageType
          # No message, it's just not supported
        rescue
          warn "Couldn't determine dimensions for image #{path}: #{$!.message}"
        end

        sum
      end

      [sizes, width, height]
    end

    def generate_svg(name, is_relative, options)
      if options[:sizes]
        sizes = options[:sizes]
        width = options[:width]
        height = options[:height]
      else
        sizes, width, height = get_image_sizes(name, options)
      end
      
      fallback_host = false
      if is_relative 
        test_path = app.asset_path(:images, "#{name}.svg")
        if is_relative_url?(test_path)
          if options.has_key?(:host)
            fallback_host = options[:host]
          else
            warn "WARNING: Inline clowncar images require absolute paths. Please set a :host value"
          end
        end
      end

      media_queries = generate_media_queries(name, sizes, is_relative, fallback_host)

      xml = SVG_TEMPLATE.dup
      xml.sub!("::media_queries::", media_queries)
      xml.sub!("::width::", width.to_s)
      xml.sub!("::height::", height.to_s)
      xml
    end

    def generate_clowncar(name, options={})
      @svg_files_to_generate << [name, options]
    end

    def manipulate_resource_list(resources)
      return resources unless @ready
      
      resources + @svg_files_to_generate.map do |name, options|
        file_name = File.join(app.images_dir, "#{name}.svg")
        output = generate_svg(name, false, options)
        ClownCarResource.new(app.sitemap, file_name, output)
      end
    end

    class ClownCarResource < ::Middleman::Sitemap::Resource
      def initialize(store, path, svg=nil)
        super(store, path, nil)

        @svg = svg
      end

      def render(opts={}, locs={}, &block)
        @svg
      end

      def ignored?
        false
      end

      def raw_data
        {}
      end

      def metadata
        @local_metadata
      end

      def binary?
        false
      end
    end

    helpers do
      def clowncar_tag(name, options={})
        internal = ""

        if options[:fallback]
          fallback_path = extensions[:clowncar].get_image_path(name, options[:fallback], true, false)
          internal = %{<!--[if lte IE 8]><img src="#{fallback_path}"><![endif]-->}
        end

        if options.has_key?(:inline) && (options[:inline] === false)
          url = asset_path(:images, "#{name}.svg")
          %Q{<object type="image/svg+xml" data="#{url}">#{internal}</object>}
        else
          data = extensions[:clowncar].generate_svg(name, true, options)
          %Q{<object type="image/svg+xml" data="data:image/svg+xml,#{::URI.escape(data)}">#{internal}</object>}
        end
      end
    end

    module ClownCarConfigAPI
      def generate_clowncar(name, options={})
        extensions[:clowncar].generate_clowncar(name, options)
      end
    end
  end
end
