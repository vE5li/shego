#functions {

    @ move somewhere else
    timed_call [ [ #single name ] [ #single function ] [ #list parameters ]
        #time
        #modify         [ #data #scope:start_time ] [ #last ]
        #call_list      [ #scope:function ] [ #scope:parameters ]
        #modify         [ #data #scope:return ] [ #last ]
        #time
        #subtract       [ #last ] [ #scope:start_time ]
        #print_line     [ #data "[ timed ] " ] [ #scope:name ] [ #data " - " ] [ #last ] [ #data "ms" ]
        #return         [ #scope:return ]
    ]

    @ move this to print module
    #print {

        color [ [ #single color ] [ #single sender ] [ #list message ]
            #call           [ #data #format:tag ] [ #scope:color ] [ #scope:sender ]
            #list           [ #last ] [ #data " " ]
            #merge          [ #last ] [ #scope:message ]
            #invoke         [ #data #print_line ] [ #last ]
        ]

        debug [ [ #list message ]
            #list           [ #root:#color:magenta ] [ #data "debug" ]
            #merge          [ #last ] [ #scope:message ]
            #call_list      [ #data #print:color ] [ #last ]
        ]

        error [ [ #list message ]
            #list           [ #root:#color:red ] [ #data "error" ]
            #merge          [ #last ] [ #scope:message ]
            #call_list      [ #data #print:color ] [ #last ]
        ]

        warning [ [ #list message ]
            #list           [ #root:#color:yellow ] [ #data "warning" ]
            #merge          [ #last ] [ #scope:message ]
            #call_list      [ #data #print:color ] [ #last ]
        ]

        success [ [ #list message ]
            #list           [ #root:#color:green ] [ #data "success" ]
            #merge          [ #last ] [ #scope:message ]
            #call_list      [ #data #print:color ] [ #last ]
        ]

        module [ [ #list message ]
            #list           [ #root:#color:cyan ] [ #data "module" ]
            #merge          [ #last ] [ #scope:message ]
            #call_list      [ #data #print:color ] [ #last ]
        ]
    }

    #tokenizer function(message, position) {
        @ print position
        set error_tag := call($#format:tag, &root:#color:red, $"error")
        print_line(error_tag ~ $" " ~ message)
    }

    #tag function(tag, message) {

        if ?not_present(&root, $debug) {
            return message
        } else &root:debug != $!true {
            return message
        }

        if ?keyword(tag) {
            set tag := call($#format:tag, &root:#color:magenta, tag)
        } else {
            set tag := call($#format:tag, &root:#color:cyan, tag)
        }
        return tag ~ $" " ~ message
    }

    #message function(message) {
        set tag := call($#format:tag, &root:#color:red, $"error")
        return tag ~ $" " ~ message
    }

    #unregistered_character function(character) {
        return $"unregistered character " ~ character
    }

    @@
    #tag [ [ #single tag ] [ #single message ]

        @ instruction tag
        #if             [ #data #keyword ] [ #scope:tag ]
        #serialize      [ #scope:tag ]
        #call           [ $#format:tag ] [ #root:#color:red ] [ #last ]
        #string         [ #last ] [ #data " " ] [ #scope:message ]
        #return         [ #last ]

        @ other tag
        #else
        #end
    ]

    #message [ [ #single message [ string ] ]
        #call           [ #function:#format:tag ] [ #root:#color:red ] [ #data "error" ]
        #string         [ #last ] [ #data " " ] [ #scope:message ]
        #return         [ #last ]
    ]

    #expected [ [ #single expected [ list ] ]
        #call           [ #function:#format:list ] [ #scope expected ] [ #data ", " ] [ #root:#color:green ]
        #string         [ #data "expected " ] [ #last ]
        #return         [ #last ]
    ]

    #expected_found [ [ #single expected [ list ] ] [ #single found ]
        #call           [ #function:#format:list ] [ #scope:expected ] [ #data ", " ] [ #root:#color:green ]
        #modify         [ #data #scope:list ] [ #last ]
        #call           [ #function:#format:debug ] [ #scope:found ]
        #string         [ #data "expected " ] [ #scope:list ] [ #data " -> found " ] [ #last ]
        #return         [ #last ]
    ]

    #expected_parameter [ [ #single index ] [ #single expected ]
        #call           [ #function:#format:list ] [ #scope:expected ] [ #data ", " ] [ #root:#color:green ]
        #string         [ #data "parameter " ] [ #scope:index ] [ #data " expected " ] [ #last ]
        #return         [ #last ]
    ]

    #expected_parameter_found [ [ #single index [ integer ] ] [ #single expected [ list ] ] [ #single found ]
        #call           [ #function:#format:list ] [ #scope:expected ] [ #data ", " ] [ #root:#color:green ]
        #modify         [ #data #scope:list ] [ #last ]
        #call           [ #function:#format:debug ] [ #scope:found ]
        #string         [ #data "parameter " ] [ #scope:index ] [ #data " expected " ] [ #scope:list ] [ #data " -> found " ] [ #last ]
        #return         [ #last ]
    ]

    #expected_return [ [ [ function:location ] ]
        #string           [ #scope function ] [ #data " expected return" ]
    ]

    #index_out_of_bounds [ [ #single index ] [ #single biggest ]
        #string         [ #data "index "] [ #scope:index ] [ #data " out of bounds; biggest is " ] [ #scope:biggest ]
        #return         [ #last ]
    ]

    #function_not_found [ [ #single location [ location ] ]
        #string           [ #data "unable to find function " ] [ #scope:location ]
    ]

    @ position
    #unregistered_character [ [ #single character [ character ] ]
        #string           [ #data "unregistered character " ] [ #scope:character ]
        #return           [ #last ]
    ]

    @ position
    #unterminated_token [ [ #single token_type [ identifier ] ]
        #string           [ #data "unterminated " ] [ #scope:token_type ]
        #return           [ #last ]
    ]

    @ position
    #invalid_token [ [ #single token_type [ identifier ] ] [ #single token ]
        #string           [ #data "invalid " ] [ #scope:token_type ] [ #data " " ] [ #scope:token ]
        #return           [ #last ]
    ]

    #register_breaking [ [ #single character [ character ] ]
        #string           [ #scope:character ] [ #data " can not be registered as breaking" ]
    ]

    #register_non_breaking [ [ #single character [ character ] ]
        #string           [ #scope:character ] [ #data " can not be registered as non breaking" ]
    ]

    #register_signature [ [ #single signature [ string ] ]
        #string           [ #data "signature " ] [ #scope:signature ] [ #data " is already in use" ]
    ]

    #string_tokenizer [ [ #single message [ string ] ]
        #return         [ #scope:message ]
    ]

    @@
}
