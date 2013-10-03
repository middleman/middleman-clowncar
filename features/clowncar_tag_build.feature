Feature: Generating SVG clowncars during preview mode

  Scenario: Basic command
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo" %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo.svg                                    |
    Then the following files should exist:
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:300px)%7Bsvg%7Bbackground-image:url(logo/small.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:301px)%20and%20(max-width:600px)%7Bsvg%7Bbackground-image:url(logo/medium.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:601px)%7Bsvg%7Bbackground-image:url(logo/big.png);%7D%7D"

  Scenario: With OldIE Fallback
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo-with-fallback", :fallback => "fallback.png" %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo-with-fallback.svg                                    |
    Then the following files should exist:
      | images/logo-with-fallback/small.png                              |
      | images/logo-with-fallback/medium.png                             |
      | images/logo-with-fallback/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:300px)%7Bsvg%7Bbackground-image:url(logo-with-fallback/small.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:301px)%20and%20(max-width:600px)%7Bsvg%7Bbackground-image:url(logo-with-fallback/medium.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:601px)%7Bsvg%7Bbackground-image:url(logo-with-fallback/big.png);%7D%7D"
    And the file "index.html" should contain "<!--[if lte IE 8]>"
    And the file "index.html" should contain '<img src="logo-with-fallback/fallback.png">'
    And the file "index.html" should contain "<![endif]-->"

  Scenario: With remote OldIE Fallback
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo", :fallback => "http://example.com/fallback.png" %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo.svg                                    |
    Then the following files should exist:
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:300px)%7Bsvg%7Bbackground-image:url(logo/small.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:301px)%20and%20(max-width:600px)%7Bsvg%7Bbackground-image:url(logo/medium.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:601px)%7Bsvg%7Bbackground-image:url(logo/big.png);%7D%7D"
    And the file "index.html" should contain "<!--[if lte IE 8]>"
    And the file "index.html" should contain '<img src="http://example.com/fallback.png">'
    And the file "index.html" should contain "<![endif]-->"

  Scenario: With custom sizes locally
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo", :sizes => { 768 => "big.png", 1024 => "medium.png", 1280 => "small.png" } %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo.svg                                    |
    Then the following files should exist:
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:768px)%7Bsvg%7Bbackground-image:url(logo/big.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:769px)%20and%20(max-width:1024px)%7Bsvg%7Bbackground-image:url(logo/medium.png);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:1025px)%7Bsvg%7Bbackground-image:url(logo/small.png);%7D%7D"

  Scenario: With single size
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo", :sizes => { 768 => "big.png" } %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo.svg                                    |
    Then the following files should exist:
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "svg%7Bbackground-image:url(logo/big.png);%7D"

  Scenario: With custom sizes remotely
    Given a fixture app "clowncar-app"
    And a file named "source/index.html.erb" with:
    """
    <%= clowncar_tag "logo", :sizes => { 333 => "//remote.com/size-333", 768 => "//remote.com/size-768", 1024 => "//remote.com/size-1024" } %>
    """
    Given a successfully built app at "clowncar-app"
    When I cd to "build"
    Then the following files should not exist:
      | images/logo.svg                                    |
    Then the following files should exist:
      | images/logo/small.png                              |
      | images/logo/medium.png                             |
      | images/logo/big.png                                |
    Then the file "index.html" should contain "<object"
    And the file "index.html" should contain "@media%20screen%20and%20(max-width:333px)%7Bsvg%7Bbackground-image:url(//remote.com/size-333);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:334px)%20and%20(max-width:768px)%7Bsvg%7Bbackground-image:url(//remote.com/size-768);%7D%7D"
    And the file "index.html" should contain "@media%20screen%20and%20(min-width:769px)%7Bsvg%7Bbackground-image:url(//remote.com/size-1024);%7D%7D"
