module Pages.ImagePath exposing
    ( ImagePath, toString, external
    , build
    )

{-| This module is analgous to `Pages.PagePath`, except it represents an
Image Path rather than a Page Path. Rather than copy-pasting those docs, I'll
note the differences here. See the `Pages.PagePath` docs for more background.


## Record-based `PagePath` lookup

You can lookup a specific static image path based on its path using the record-based lookup:

    Pages.images

This gives you a record, based on all the files in your local
`images` directory, that lets you look paths up like so:

    import Pages
    import Pages.ImagePath as ImagePath exposing (ImagePath)

    homePath : ImagePath Pages.PathKey
    homePath =
        Pages.pages.index

    -- ImagePath.toString homePath
    -- => ""

or

    import Pages
    import Pages.ImagePath as ImagePath exposing (ImagePath)

    dillonProfilePhoto : ImagePath Pages.PathKey
    dillonProfilePhoto =
        Pages.images.profilePhotos.dillon

    -- ImagePath.toString helloWorldPostPath
    -- => "images/profile-photos/dillon.jpg"

@docs ImagePath, toString, external


## Functions for code generation only

Don't bother using these.

@docs build

-}


{-| There are only two ways to get an `ImagePath`:

1.  Get a value using the generated `Pages.elm` module in your repo (see above), or
2.  Generate an external route using `PagePath.external`.

So `ImagePath` represents either a 1) known, static image asset path, or 2) an
external image path (which is not validated so use these carefully!).

-}
type ImagePath key
    = Internal (List String)
    | External String


{-| Gives you the image's relative URL as a String. This is useful for constructing `<img>` tags:

    import Html exposing (Html, img)
    import Html.Attributes exposing (src)
    import Pages
    import Pages.ImagePath as ImagePath exposing (ImagePath)


    -- `Pages` is a generated module
    logoImagePath : ImagePath Pages.PathKey
    logoImagePath =
        Pages.pages.index

    linkToHome : Html msg
    linkToHome =
        img [ src (ImagePath.toString logoImagePath) ] []

-}
toString : ImagePath key -> String
toString path =
    case path of
        Internal rawPath ->
            String.join "/" rawPath

        External url ->
            url


{-| This is not useful except for the internal generated code to construct an `ImagePath`.
-}
build : key -> List String -> ImagePath key
build key path =
    Internal path


{-| This allows you to build a URL to an external resource. Avoid using
`ImagePath.external` to refer to statically available image resources. Instead, use
this only to point to outside images.

    import Pages
    import Pages.ImagePath as ImagePath exposing (ImagePath)


    -- The `Pages` module is generated in your codebase.
    -- Notice that we can still annotate this external image
    -- with `Pages.PathKey`, since external images are always valid
    -- (unlike internal images, which are guaranteed to be present
    -- if your code compiles).
    benchmarkImagePath : ImagePath Pages.PathKey
    benchmarkImagePath =
        PagePath.external "https://elm-lang.org/assets/home/benchmark.png"

    -- ImagePath.toString benchmarkImagePath
    -- => "https://elm-lang.org/assets/home/benchmark.png"

-}
external : String -> ImagePath key
external url =
    External url
