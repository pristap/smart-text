## Summary

  SmartText is an Elm library for parsing hashtags & mentions from plain text input.

## Usage

  SmartText is simple to use, it has only 1 function exposed - `parse` which does all the job.
  
  It takes plain text & returns a list of `Element`s divided as plain text, mentions & hashtags for You to further appropriately display it.

    > tweet = SmartText.parse "Sample #smart_text 👨🏻‍💻 with ❤️ by @kexoth."
    [Text "Sample ",HashTag "#smart_text",Text " 👨🏻‍💻 with ❤️ by ",Mention "@kexoth",Text "."]
        : List SmartText.Element

There is also a sample program in `examples/` to try it out.
