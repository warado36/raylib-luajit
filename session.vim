let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/projects/luaga
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +16 main.lua
badd +139 ~/projects/raylib/examples/textures/textures_draw_tiled.c
badd +1 ffibindings.lua
badd +1 ~/projects/raylib/src/raylib.h
badd +293 /usr/local/include/raylib.h
argglobal
%argdel
$argadd main.lua
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit main.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 64 + 62) / 124)
exe 'vert 2resize ' . ((&columns * 59 + 62) / 124)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
13,15fold
27,34fold
36,47fold
50,52fold
56,61fold
63,68fold
55,69fold
81,86fold
81,91fold
80,92fold
95,98fold
94,99fold
77,100fold
103,104fold
115,120fold
122,128fold
130,136fold
137,142fold
143,149fold
151,157fold
158,161fold
112,164fold
76,165fold
17,166fold
let &fdl = &fdl
let s:l = 159 - ((14 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 159
normal! 059|
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/raylib/examples/textures/textures_draw_tiled.c", ":p")) | buffer ~/projects/raylib/examples/textures/textures_draw_tiled.c | else | edit ~/projects/raylib/examples/textures/textures_draw_tiled.c | endif
if &buftype ==# 'terminal'
  silent file ~/projects/raylib/examples/textures/textures_draw_tiled.c
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
1,16fold
46,53fold
68,73fold
61,74fold
95,99fold
93,100fold
105,109fold
103,110fold
88,111fold
118,119fold
146,150fold
83,164fold
31,174fold
193,196fold
199,203fold
209,212fold
215,219fold
228,231fold
233,237fold
225,238fold
244,248fold
251,255fold
241,256fold
205,257fold
189,257fold
183,257fold
177,258fold
let &fdl = &fdl
let s:l = 145 - ((9 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 145
normal! 0
lcd ~/projects/luaga
wincmd w
exe 'vert 1resize ' . ((&columns * 64 + 62) / 124)
exe 'vert 2resize ' . ((&columns * 59 + 62) / 124)
tabnext
edit ~/projects/luaga/ffibindings.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 76 + 62) / 124)
exe 'vert 2resize ' . ((&columns * 47 + 62) / 124)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,8fold
10,15fold
17,23fold
26,31fold
4,45fold
54,56fold
58,60fold
62,64fold
66,68fold
70,72fold
74,76fold
78,80fold
82,84fold
86,88fold
90,92fold
94,96fold
98,100fold
104,132fold
134,151fold
154,161fold
let &fdl = &fdl
let s:l = 98 - ((20 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 98
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/luaga/ffibindings.lua", ":p")) | buffer ~/projects/luaga/ffibindings.lua | else | edit ~/projects/luaga/ffibindings.lua | endif
if &buftype ==# 'terminal'
  silent file ~/projects/luaga/ffibindings.lua
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,8fold
10,15fold
17,23fold
26,31fold
4,45fold
54,56fold
58,60fold
62,64fold
66,68fold
70,72fold
74,76fold
78,80fold
82,84fold
86,88fold
90,92fold
94,102fold
104,132fold
134,151fold
154,161fold
let &fdl = &fdl
4
normal! zo
let s:l = 21 - ((20 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 21
normal! 025|
wincmd w
exe 'vert 1resize ' . ((&columns * 76 + 62) / 124)
exe 'vert 2resize ' . ((&columns * 47 + 62) / 124)
tabnext
edit /usr/local/include/raylib.h
argglobal
balt ~/projects/raylib/src/raylib.h
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
1,83fold
99,101fold
104,105fold
102,106fold
108,110fold
107,110fold
98,111fold
113,115fold
120,122fold
123,125fold
126,128fold
132,134fold
135,137fold
138,140fold
141,143fold
150,151fold
148,152fold
157,159fold
209,211fold
207,212fold
215,218fold
221,225fold
228,233fold
239,244fold
247,252fold
255,260fold
263,269fold
272,278fold
287,291fold
297,304fold
307,313fold
316,323fold
326,332fold
337,342fold
345,369fold
372,375fold
378,382fold
385,389fold
392,396fold
399,402fold
405,418fold
421,427fold
430,433fold
436,441fold
444,447fold
450,456fold
464,471fold
474,477fold
480,487fold
490,500fold
503,512fold
515,519fold
522,526fold
529,533fold
541,558fold
562,571fold
576,691fold
699,707fold
710,722fold
725,744fold
747,754fold
757,769fold
775,806fold
812,826fold
829,834fold
838,863fold
868,875fold
878,883fold
886,892fold
895,899fold
902,911fold
915,927fold
930,936fold
939,942fold
945,949fold
968,1712fold
85,1714fold
let &fdl = &fdl
let s:l = 215 - ((11 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 215
normal! 0
lcd ~/projects/luaga
tabnext 2
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
