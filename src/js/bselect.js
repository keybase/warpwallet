/*!
 * BSelect v0.3.4 - 2013-07-11
 * 
 * Created by Gustavo Henke <gustavo@injoin.com.br>
 * http://gustavohenke.github.io/bselect/
 */
(function( $, undefined ) {
    "use strict";

    var elements = 0;
    var dataName = "bselect";
    var instances = [];
    var bootstrapButtonSizes = [ "mini", "small", "large" ];
    var sliceArray = Array.prototype.slice;

    var methods = {
        // Get/set options of the component
        option: function( option, value ) {
            var curr = this.data( dataName ).options || {},
                prev = $.extend( {}, curr );

            if ( typeof option === "string" && option[ 0 ] !== "_" ) {
                if ( value === undefined ) {
                    return curr[ option ];
                } else {
                    curr[ option ] = value;
                    updateOptions( this, prev, curr );

                    return this;
                }
            } else if ( $.isPlainObject( option ) ) {
                $.extend( curr, option );
                updateOptions( this, prev, curr );

                this.data( dataName ).options = curr;
            }

            return curr;
        },

        // Retrieve the BSelect container
        element: function() {
            return this.data( dataName ).element;
        },

        toggle: function( e ) {
            if ( this[ 0 ].disabled ) {
                return this;
            }

            var bselect = _callMethod( this, "element" );

            if ( e instanceof $.Event ) {
                var option = _callMethod( this, "option", "showOn" );
                //e.stopPropagation();

                if ( $( e.target ).is( ".bselect-label" ) && option !== "both" ) {
                    return this;
                }
            }

            if ( bselect.find( ".bselect-dropdown" ).is( ":hidden" ) ) {
                _callMethod( this, "show" );
            } else {
                _callMethod( this, "hide" );
            }

            return this;
        },
        show: function() {
            var searchInput, activeItem, bselect, dropdown, inputWidth;
            var data = this.data( dataName );

            if ( this[ 0 ].disabled || data.open ) {
                return this;
            }

            bselect = data.element;
            dropdown = bselect.find( ".bselect-dropdown" );

            dropdown.css( "left", "-9999em" ).show();
            adjustDropdownHeight( bselect );

            // Adjust the scrolling to match the current select option position - issue #10
            activeItem = bselect.find( ".bselect-option.active" );
            if ( activeItem.length ) {
                var optionList = bselect.find( ".bselect-option-list" ),
                    activeItemPos = activeItem.position().top,
                    optionListPos = optionList.position().top;

                if ( activeItemPos - optionListPos < optionList.height() ) {
                    optionList.scrollTop( 0 );
                } else {
                    optionList.scrollTop( activeItemPos - optionListPos );
                }
            }

            dropdown.hide().css( "left", "auto" );

            dropdown.slideDown( _callMethod( this, "option", "animationDuration" ) );
            this.data( dataName, $.extend( data, {
                open: true
            }));

            // The following class will allow us to show that nice inset shadow in .dropdown-toggle
            bselect.addClass( "open" );

            // Adjust the size of the search input to match the container inner width
            searchInput = bselect.find( ".bselect-search-input" ).focus();
            inputWidth = searchInput.parent().width() - searchInput.next().outerWidth();
            searchInput.innerWidth( inputWidth );

            bselect.find( ".bselect-search-input" ).attr( "aria-expanded", "true" );

            return this;
        },
        hide: function( clear ) {
            var data = this.data( dataName );
            if ( this[ 0 ].disabled || !data.open ) {
                return this;
            }

            var options = data.options,
                bselect = data.element;

            clear = clear === undefined ? true : clear;

            this.data( dataName, $.extend( data, {
                open: false
            }));

            bselect.find( ".bselect-dropdown" ).slideUp( options.animationDuration );
            bselect.removeClass( "open" );

            // Clear the search input and the results, if that's case
            if ( clear && options.clearSearchOnExit ) {
                _callMethod( this, "clearSearch" );
            }

            bselect.find( ".bselect-search-input" ).attr( "aria-expanded", "false" );

            return this;
        },
        select: function( arg ) {
            var $elem, val;
            var bselect = _callMethod( this, "element" );

            if ( arg instanceof $.Event ) {
                $elem = $( arg.currentTarget );
            } else {
                $elem = bselect.find( "li" ).eq( arg );

                if ( !$elem.length ) {
                    return this;
                }
            }

            // Remove the highlighted status from any previously selected item...
            var index = bselect.find( "li" )
                               .removeClass( "active" )
                               .attr( "aria-selected", "false" )
                               .index( $elem );

            var option = this.find( "option[value!='']" ).get( index );

            // Trigger the selected event
            this.trigger( "bselectselect", [ option ] );

            // ...and add to the new selected item :)
            val = $elem.addClass( "active" ).data( "value" );
            $elem.attr( "aria-selected", "true" );

            bselect.find( ".bselect-label" ).text( $elem.text() );
            _callMethod( this, "hide" );

            // We'll keep up-to-date the old select, too
            this.data( dataName ).tempDisable = true;
            this.val( val ).trigger( "change" );

            // Trigger the selected event
            this.trigger( "bselectselected", [ val, option ] );

            return this;
        },

        // Searches every item in the list for the given text
        search: function( arg ) {
            var listItems, listItem, i, len, results;
            var options = _callMethod( this, "option" );
            var searched = arg instanceof $.Event ? arg.target.value : arg;
            var bselect = _callMethod( this, "element" );

            if ( this[ 0 ].disabled ) {
                return this;
            }

            // Avoid searching for nothing
            if ( searched === "" ) {
                _callMethod( this, "clearSearch" );
            }

            if ( !( arg instanceof $.Event ) ) {
                bselect.find( ".bselect-search" ).val( searched );
            }

            // Same search/few chars? We won't search then!
            if (
                ( searched === options.lastSearch ) ||
                ( searched.length < options.minSearchInput )
            ) {
                return;
            }

            // Initialize the result collection
            results = $();

            listItems = bselect.find( "li" ).hide();
            for ( i = 0, len = listItems.length; i < len; i++ ) {
                listItem = listItems[ i ];
                if ( listItem.textContent.toLowerCase().indexOf( searched.toLowerCase() ) > -1 ) {
                    results = results.add( $( listItem ).show() );
                }
            }

            if ( results.length === 0 ) {
                showNoOptionsAvailable( this );
            } else {
                bselect.find( ".bselect-message" ).hide();
            }

            this.trigger( "bselectsearch", [ searched, results ] );

            adjustDropdownHeight( listItems.end() );
            return this;
        },

        clearSearch: function() {
            var bselect = _callMethod( this, "element" );

            bselect.find( ".bselect-search-input" ).val( "" );
            bselect.find( "li" ).show();
            bselect.find( ".bselect-message" ).hide();

            adjustDropdownHeight( bselect );

            return this;
        },

        // Disable the bselect instance
        disable: function() {
            if ( !this[ 0 ].disabled ) {
                _callMethod( this, "element" ).addClass( "disabled" );
                this.prop( "disabled", true );
            }

            return this;
        },

        // Enable the bselect instance
        enable: function() {
            if ( this[ 0 ].disabled ) {
                _callMethod( this, "element" ).removeClass( "disabled" );
                this.prop( "disabled", false );
            }

            return this;
        },

        // Refreshes the option list. Useful when new HTML is added
        refresh: function() {
            var bselect = _callMethod( this, "element" );
            var optionList = bselect.find( ".bselect-option-list" ).empty();
            var mapping = {};
            var i = 0;

            bselect.toggleClass( "disabled", this.prop( "disabled" ) );

            this.find( "option, > optgroup" ).each(function() {
                var classes, li;
                var isOption = $( this ).is( "option" );

                if ( isOption && !this.value ) {
                    return;
                }

                if ( isOption ) {
                    classes = "bselect-option";
                    if ( $( this ).closest( "optgroup" ).length ) {
                        classes += " grouped";
                    }
                } else {
                    classes = "bselect-option-group";
                }

                li = $( "<li />" ).attr({
                    "class": classes,
                    // While there aren't roles for optgroup, we'll stick with the role option.
                    role: "option",
                    tabindex: isOption ? 2 : -1,
                    "aria-selected": "false"
                });

                if ( isOption ) {
                    li.data( "value", this.value );
                    mapping[ this.value ] = i;

                    li.html( "<a href='#'>" + this.text + "</a>" );
                } else {
                    li.text( this.label );
                }

                li.appendTo( optionList );
                i++;
            });

            if ( i === 0 ) {
                showNoOptionsAvailable( this );
            }

            this.data( dataName ).itemsMap = mapping;
            return this;
        },

        destroy: function() {
            var bselect = _callMethod( this, "element" );
            this.data( dataName, null );

            // Remove our cached thing
            instances.splice( instances.indexOf( this ), 1 );

            bselect.remove();
            this.removeClass( "bselect-inaccessible" ).unbind( ".bselect" );
            return this;
        }
    };

    // Determine whether an DOM Element has bselect instance
    function hasBSelect( el ) {
        return $.isPlainObject( $( el ).data( dataName ) );
    }

    // Helper function that will call an BSelect method in the context of $elem
    function _callMethod( $elem, method ) {
        if ( methods[ method ] !== undefined ) {
            return methods[ method ].apply( $elem, sliceArray.call( arguments, 2 ) );
        }

        return $elem;
    }

    /**
     * Get the placeholder of an element.
     * Retrieves in the following order:
     * - bselect options
     * - .data("placeholder") / attribute data-placeholder
     * - Default bselect i18n "selectAnOption"
     */
    function getPlaceholder( $elem ) {
        return _callMethod( $elem, "option", "placeholder" ) ||
               $elem.data( "placeholder" ) ||
               $.bselect.i18n.selectAnOption;
    }

    // Adjusts the dropdown height of an bselect.
    function adjustDropdownHeight( $elem ) {
        var list = $elem.find( ".bselect-option-list" );
        var len = list.find( "li:visible" ).length;

        list.innerHeight( parseInt( list.css( "line-height" ), 10 ) * 1.5 * ( len < 5 ? len : 5 ) );
    }

    // Updates visual properties of the bselect after the plugin was initialized
    function updateOptions( $elem, prev, curr ) {
        var bselect = _callMethod( $elem, "element" );

        $.each( prev, function(key, val) {
            if ( curr[ key ] !== val ) {
                if ( key === "size" ) {
                    var sizes = $.map( bootstrapButtonSizes.slice( 0 ), function( size ) {
                        return "bselect-" + size;
                    }).join( " " );

                    bselect.removeClass( sizes );
                    if ( bootstrapButtonSizes.indexOf( curr.size ) > -1 ) {
                        bselect.addClass( "bselect-" + curr.size );
                    }
                }
            }
        });
    }

    // Show the 'no options available' message
    function showNoOptionsAvailable( $elem ) {
        var bselect = _callMethod( $elem, "element" );
        bselect.find( ".bselect-message" ).text( $.bselect.i18n.noOptionsAvailable ).show();
    }

    /**
     * Handle keypress on the search input and on the options.
     * - On the search input: arrow up goes to the last visible item, while arrow down
     *   does the opposite.
     * - In the options, arrows are used to navigate and enter to select.
     */
    function handleKeypress( e ) {
        if ( e.keyCode !== 38 && e.keyCode !== 40 && e.keyCode !== 13 ) {
            return;
        }

        var $this = $( this ),
            isInput = $this.is( ".bselect-search-input" );

        switch ( e.keyCode ) {
            // UP
            case 38:
                if ( isInput ) {
                    $( e.delegateTarget ).find( ".bselect-option:visible:last" ).focus();
                } else {
                    $this.prevAll( ".bselect-option:visible" ).eq( 0 ).focus();
                }
                break;

            // DOWN
            case 40:
                if ( isInput ) {
                    $( e.delegateTarget ).find( ".bselect-option:visible:first" ).focus();
                } else {
                    $this.nextAll( ".bselect-option:visible" ).eq( 0 ).focus();
                }
                break;

            // ENTER
            case 13:
                if ( !isInput ) {
                    $this.trigger( "click" );
                }
                break;
        }

        return false;
    }

    // Run all the setup stuff
    function setup( elem, options ) {
        var caret, label, container, id, dropdown;
        var $elem = $( elem );

        // First of, let's build the base HTML of BSelect
        id = ++elements;
        container = $( "<div class='bselect' />", {
            id: "bselect-" + id
        });

        dropdown = $( "<div class='bselect-dropdown' />" );

        // Configure the search input
        if ( options.searchInput === true ) {
            var search = $( "<div class='bselect-search' />" );

            $( "<input type='text' class='bselect-search-input' />" ).attr({
                role: "combobox",
                tabindex: 1,
                "aria-expanded": "false",
                "aria-owns": "bselect-option-list-" + id

                // The W3C documentation says that role="combobox" should have aria-autocomplete,
                // but the validator tells us that this is invalid. Very strange.
                //"aria-autocomplete": "list"
            }).appendTo( search );

            //$( "<span class='bselect-search-icon' />" )
            //    .append( "<i class='glyphicon glyphicon-search'></i>" )
            //    .appendTo( search );

            search.appendTo( dropdown );
        }

        $( "<div class='bselect-message' role='status' />" ).appendTo( dropdown );

        $( "<ul class='bselect-option-list' />" ).attr({
            id: "bselect-option-list-" + id,
            role: "listbox"
        }).appendTo( dropdown );

        container.append( dropdown ).insertAfter( $elem );

        // Save some precious data in the original select now, as we have the container in the DOM
        $elem.data( dataName, {
            options: options,
            element: container,
            open: false
        });

        updateOptions( $elem, $.bselect.defaults, options );
        _callMethod( $elem, "refresh" );

        $elem.bind( "bselectselect.bselect", options.select );
        $elem.bind( "bselectselected.bselect", options.selected );
        $elem.bind( "bselectsearch.bselect", options.search );

        label = $( "<span />" ).addClass( "bselect-label" ).text( getPlaceholder( $elem ) );
        caret = $( "<button type='button' />" ).addClass( "bselect-caret" )
                                               .html( "<span class='caret'></span>" );
        container.prepend( caret ).prepend( label );

        label.outerWidth( $elem.outerWidth() - caret.outerWidth() );

        // Hide this ugly select!
        $elem.addClass( "bselect-inaccessible" );

        // We'll cache the container for some actions
        instances.push( $elem );

        // Event binding
        container.find( ".bselect-search-input" ).keyup( $.proxy( methods.search, $elem ) );
        container.on( "click", ".bselect-option", $.proxy( methods.select, $elem ) );
        container.on( "click", ".bselect-caret, .bselect-label", $.proxy( methods.toggle, $elem ) );
        container.on( "keydown", ".bselect-option, .bselect-search-input", handleKeypress );

        // Issue #6 - Listen to the change event and update the selected value
        $elem.bind( "change.bselect", function() {
            var data = $elem.data( dataName );
            var index = data.itemsMap[ this.value ];

            if ( data.tempDisable ) {
                data.tempDisable = false;
                return;
            }

            _callMethod( $elem, "select", index );
        }).trigger( "change.bselect" );
    }

    $.fn.bselect = function( arg ) {
        if ( typeof arg === "string" && this[ 0 ] ) {
            if ( hasBSelect( this[ 0 ] ) && methods[ arg ] !== undefined ) {
                return methods[ arg ].apply( $( this[ 0 ] ), sliceArray.call( arguments, 1 ) );
            }

            return this;
        }

        return this.each(function() {
            // #8 - avoid creating bselect again on the same element
            if ( hasBSelect( this ) ) {
                return;
            }

            arg = $.isPlainObject( arg ) ? arg : {};
            arg = $.extend( {}, $.bselect.defaults, arg );

            setup( this, arg );
        });
    };

    $.bselect = {
        defaults: {
            size: "normal",
            showOn: "both",
            clearSearchOnExit: true,
            minSearchInput: 0,
            animationDuration: 300,
            searchInput: true,
            search: null,
            select: null,
            selected: null
        },
        i18n: {
            selectAnOption: "Select an option",
            noOptionsAvailable: "No options available."
        }
    };

    $( document ).on( "click.bselect", "label", function( e ) {
        var i, len, id;

        for ( i = 0, len = instances.length; i < len; i++ ) {
            id = instances[ i ][ 0 ].id;
            if ( id && $( e.target ).attr( "for" ) === id ) {
                _callMethod( instances[ i ], "show" );
                return false;
            }
        }
    }).on( "click.bselect", function( e ) {
        var i, len, data;

        for ( i = 0, len = instances.length; i < len; i++ ) {
            data = instances[ i ].data( dataName );

            if ( data.open && !data.element.has( e.target ).length ) {
                _callMethod( instances[ i ], "hide" );
            }
        }
    });

    // #18 - resizing within the original element
    $( window ).resize(function() {
        var i, len, data, caret;

        for ( i = 0, len = instances.length; i < len; i++ ) {
            data = instances[ i ].data( dataName );
            caret = data.element.find( ".bselect-caret" );

            data.element.find( ".bselect-label" )
                        .outerWidth( instances[ i ].outerWidth() - caret.outerWidth() );
        }
    });

})( jQuery );
