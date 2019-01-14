"/
"/ Color Util Functions
"/ The conversion functions here were largely copied from `https://github.com/romgrk/lib.kom`.
"/

let g:loaded_color_util = 1

let s:patterns = {}

"6 hex-numbers, optionnal #-prefix
let s:patterns['hex']      = '\v#?(\x{2})(\x{2})(\x{2})'

"short version is strict: starting # mandatory
let s:patterns['shortHex'] = '\v#(\x{1})(\x{1})(\x{1})'

"/ Convert RGB to Hex.
"/
"/ @params (r, g, b)
"/ @params ([r, g, b])
"/ @returns String           A RGB color
function! color#RGBToHex (...)
    let [r, g, b] = ( a:0==1 ? a:1 : a:000 )
    let num = printf('%02x', float2nr(r)) . ''
          \ . printf('%02x', float2nr(g)) . ''
          \ . printf('%02x', float2nr(b)) . ''
    return '#' . num
endfunction

"/ Convert Hex to RGB.
"/
"/ @param {String|Number} color   The color to parse
function! color#HexToRGB (color)
    if type(a:color) == 2
        let color = printf('%x', a:color)
    else
        let color = a:color | end

    let matches = matchlist(color, s:patterns['hex'])
    let factor  = 0x1

    if empty(matches)
        let matches = matchlist(color, s:patterns['shortHex'])
        let factor  = 0x10
    end

    if len(matches) < 4
        echohl Error
        echom 'Couldnt parse ' . string(color) . ' ' .  string(matches)
        echohl None
        return | end

    let r = str2nr(matches[1], 16) * factor
    let g = str2nr(matches[2], 16) * factor
    let b = str2nr(matches[3], 16) * factor

    return [r, g, b]
endfunction

"/ Lighten a color by percentage.
"/
"/ @params String                 color      The color
"/ @params {Number|String|Float} [amount=5]  The percentage of light
function! color#Lighten(color, ...)
    let amount = a:0 ?
                \(type(a:1) < 2 ?
                    \str2float(a:1) : a:1 )
                \: 5.0

    if(amount < 1.0)
        let amount = 1.0 + amount
    else
        let amount = 1.0 + (amount / 100.0)
    end

    let rgb = color#HexToRGB(a:color)
    let rgb = map(rgb, 'v:val * amount')
    let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
    let rgb = map(rgb, 'float2nr(v:val)')
    let hex = color#RGBToHex(rgb)
    return hex
endfunction

"/ Darken a color by percentage.
"/
"/ @params String                 color      The color
"/ @params {Number|String|Float} [amount=5]  The percentage of darkness
function! color#Darken(color, ...)
    let amount = a:0 ?
                \(type(a:1) < 2 ?
                    \str2float(a:1) : a:1 )
                \: 5.0

    if(amount < 1.0)
        let amount = 1.0 - amount
    else
        let amount = 1.0 - (amount / 100.0)
    end

    if(amount < 0.0)
        let amount = 0.0 | end


    let rgb = color#HexToRGB(a:color)
    let rgb = map(rgb, 'v:val * amount')
    let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
    let rgb = map(rgb, 'float2nr(v:val)')
    let hex = color#RGBToHex(rgb)
    return hex
endfunction

"/
"/ Helper function for getting the HEX value of a highlight group.
"/
function! color#GetHighlight(group, term)
   " Store output of group to variable
   let output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction

"/
"/ Apply syntax highlight to a highlight group.
"/
function! color#Highlight(group, fg, bg, attr)
    if !empty(a:fg)
        exec 'hi ' . a:group . ' guifg=' . a:fg
    endif
    if !empty(a:bg)
        exec 'hi ' . a:group . ' guibg=' . a:bg
    endif
    if !empty(a:attr)
        exec 'hi! ' . a:group . ' gui=' . a:attr . ' cterm=' . a:attr
    endif
endfunction
