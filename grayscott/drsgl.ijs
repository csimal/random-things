NB. This script computes a simulation of a diffusion reaction system

load 'viewmat'
load '~addons/graphics/color/rgb.ijs'




NB. =========================================================
gl2_run=: 3 : 0
NB.if. -. checkrequire 'gl2';'graphics/gl2' do. return. end.
require 'gl2'
coinsert 'jgl2'
require 'gles'
coinsert 'jgles'
NB.require '~addons/ide/qt/opengl.ijs'
NB.coinsert 'qtopengl'
wd FORM
wd 'ptimer 200'
wd 'pshow'
NB. should not be needed on other platforms..
EMPTY
)

demo_timer=: 3 : 0
if. 1=PAUSE do. return. end.
cells =: grayscott^:(10) cells
t =: t+10
gl_paint''
)

gl2_render =: 3 : 0
gl_paintx ''
)

demo_gs_initialize =: 3 : 0
if. p=. glGetString GL_VERSION do. smoutput 'GL_VERSION: ', memr 0 _1 2,~ p end.
if. 0=p do. smoutput 'cannot retrieve GL_VERSION' return. end.
if. p=. glGetString GL_VENDOR do. smoutput 'GL_VENDOR: ', memr 0 _1 2,~ p end.
if. p=. glGetString GL_RENDERER do. smoutput 'GL_RENDERER: ', memr 0 _1 2,~ p end.
if. p=. glGetString GL_SHADING_LANGUAGE_VERSION do. smoutput 'GL_SHADING_LANGUAGE_VERSION: ', memr 0 _1 2,~ p end.
GLSL=: wglGLSL''

wglPROC''
sprog=: 0
if. GLSL>120 do.
  vsrc=. vsrc2
  fsrc=. fsrc2
else.
  vsrc=. vsrc1
  fsrc=. fsrc1
  if. 0=GLES_VERSION_jgles_ do.
    vsrc=. vsrc,~ '#define lowp', LF, '#define mediump', LF, '#define highp', LF
    fsrc=. fsrc,~ '#define lowp', LF, '#define mediump', LF, '#define highp', LF
  end.
end.
vsrc=. '#version ',(":GLSL),((GLSL>:300)#(*GLES_VERSION){::' core';' es'),LF,vsrc
fsrc=. '#version ',(":GLSL),((GLSL>:300)#(*GLES_VERSION){::' core';' es'),LF,fsrc
if.(GLSL>:300)*.0~:GLES_VERSION_jgles_ do.
  fsrc=. ('void main';'out vec4 gl_FragColor;',LF,'void main') stringreplace fsrc
end.
smoutput vsrc
smoutput fsrc
'err program'=. gl_makeprogram vsrc;fsrc
if. #err do. smoutput err return. end.


sprog=: program

glClearColor 0; 0; 1; 0
)

demo_gs_paint =: 3 : 0
gl_pixels 0 0, w, h,,toargb cells
)

NB. =========================================================
FORM=: 0 : 0
pc demo;pn "Diffusion-Reaction Simulation";
minwh 450 450;
bin h;
cc gs opengl flush;
linev;
bin vs;
groupbox "Seed";
bin v;
bin h; cc sul static; cn "u:"; cc su dspinbox 2 0 0.01 1 1; bin z;
bin h; cc svl static; cn "v:"; cc sv dspinbox 2 0 0.01 1 0.5; bin z;
cc Random button; cn "Random";
cc Uniform button; cn "Uniform";
cc Square button; cn "Square";
cc Smooth button; cn "Smooth";
bin z;
groupboxend;
groupbox "Simulation";
bin v;
bin h; cc dul static; cn "Du:"; cc du dspinbox 2 0 0.01 1 1; bin z;
bin h; cc dvl static; cn "Dv:"; cc dv dspinbox 2 0 0.01 1 0.5; bin z;
bin h; cc fl static; cn "f:"; cc fval dspinbox 3 0 0.01 1 0.055; bin z;
bin h; cc kl static; cn "k:"; cc kval dspinbox 3 0 0.01 1 0.062; bin z;
cc Update button; cn "Update";
bin z;
groupboxend;
cc Pause button; cn "Pause";
cc Save button; cn "Save image";
bin zz;
pas 6 6;
)

suc =: 1
svc =: 0.5
sc =: suc,svc NB. seed coefficients

demo_su_changed =: 3 : 0
suc=: 0".su
sc =: suc,svc
)

demo_sv_changed =: 3 : 0
svc =: 0".sv
sc =: suc,svc
)

demo_Random_button =: 3 : 0
t =: 0
cells =: sc*"1 ? ($cells)$0
gl2_render''
)

demo_Uniform_button =: 3 : 0
t =: 0
cells =: ($cells)$ sc
gl2_render''
)

demo_Square_button =: 3 : 0
t =: 0
cells =: sc*"1 seed
gl2_render''
)

smooth =: 3 3 $ 0.025 0.1 0.025 0.1 0.5 0.1 0.025 0.1 0.025

demo_Smooth_button =: 3 : 0
cells =: constraint smooth convolve cells
gl2_render''
)

demo_du_changed =: 3 : 0
Du =: 0".du
D =: Du,Dv
)

demo_dv_changed =: 3 : 0
Dv =: 0".dv
D =: Du,Dv
)

demo_fval_changed =: 3 : 0
f =: 0".fval
)

demo_kval_changed =: 3 : 0
k =: 0".kval
)

demo_Update_button =: 3 : 0
cells =: grayscott^:20 cells
t =: t+20
gl2_render''
)

PAUSE =: 1

demo_Pause_button =: 3 : 0
PAUSE =: -.PAUSE
if. PAUSE do. 
wd'set Pause text "Unpause"'
else. wd'set Pause text "Pause"' end.
)

demo_Save_button =: 3 : 0
viewrgb torgb cells
savemat_jviewmat_ '~temp/drs_',(2}.":f),'_',(2}.":k),'_',(":t), '.png'
closeall_jviewmat_ ''
)

demo_close =: 3 : 0
STOP =: 1
glDeleteBuffers ::0: 2; vbo
glDeleteProgram ::0: sprog
wd 'pclose'
)

NB. =========================================================

NB. pad operates on a table as if it were of rank 2
NB. and adds padding of the same rank as the elements around it
NB. dyadic form uses x as the number of layers to add
pad =: verb define
p =. (0&,)@:(0&(,~))
p (p"(_1)) y
:
(pad^:(x)) y
)

NB. depad is the obverse of pad
NB. it crops an array on it's two leading axises
NB. dyadic form uses x as the number of layers to crop 
depad =: verb define
dp =. (}.)@:(}:)
dp"(_1) (dp) y
:
(depad^:(x)) y
)

NB. convolve applies an odd sized square convolution matrix x on y
convolve =: dyad define
breadth =. }. $ x NB. the breadth of the convolution matrix
NB. i: <. -: breadth NB. should be equivalent to below, but isn't
rv =. |:  <:^:(-: <: breadth) i.breadth NB. the base rotation values
rots =. rv (,"1)/ rv NB. the matrix of all rotation vectors to be applied
+/ +/ (x * (rots |./"_ y))
)

colors =: |. 255 64 0,: 0 128 255 NB. white and black

NB. converts cells into a matrix of rgb integers
torgb =: monad define
u =. {."1 y
v =. {:"1 y
NB.RGB"1 @  <. (($u)$255) &* u-v
RGB"1 <. +/"2 y*(($y))$colors
)

toargb =: monad define
NB. must add 0xff000000 for color to show in gl2 
4278190080 + torgb y
)

NB. ==============================================================


NB. contrains y between 0 and 1 by cropping any excess
constraint =: monad define
0 >. 1 <. y
)

size =: 450 NB. the size of the grid

NB. below is the initial grid with a 10 by 10 seed in the center
seed =: cells =: ((size, size, 2 )$ 1 0) + ((-:size)-25) pad (50 50 2 $ 0 1)

dm =: 3 3 $ 0.05 0.2 0.05 0.2 _1 0.2 0.05 0.2 0.05 NB. diffusion matrix
Du =: 1
Dv =: 0.5
D =: 1 0.5 NB. diffusion coefficients
f =: 0.030 NB. feed
k =: 0.057 NB. kill

NB. computes the reaction (feed and kill) part of the gray-scott model
gs =: dyad define
s =. ($ x),2
r =. x**:y
u =. (s$ 1 0)*( (f*(1-x)) - r)
v =. (s$ 0 1)*( r - (k+f)*y)
 u + v
)

NB. computes an iteration of gray-scott model
grayscott =: monad define
u =. {."1 y
v =. {:"1 y
constraint y + (D*"1(dm convolve y)) + (u gs v)
)

NB.left =: {."1 cells
NB.right =: {:"1 cells

NB.viewrgb torgb grayscott^:100 cells
NB.<"1 left gs right
NB.<"0 torgb cells

w =: h =: size
t =: 0

gl2_run''

gl2_render''

main =: 3 : 0

STOP =: 0

for. i.10 do.
  NB.if. PAUSE do. continue. end.
  cells =: grayscott cells
  t =: >:t
  gl2_render''
  NB.glpaintx ''
  6!:3 (0.05)
end.
)

NB.main''

NB. =============================================================
NB. =========================================================
vsrc1=: 0 : 0
attribute highp vec3 vertex;
attribute lowp vec3 color;
varying lowp vec4 v_color;
uniform mat4 mvp;
void main(void)
{
  gl_Position = mvp * vec4(vertex,1.0);
  v_color = vec4(color,1.0);
}
)

fsrc1=: 0 : 0
varying lowp vec4 v_color;
void main(void)
{
  gl_FragColor = v_color;
}
)

NB. =========================================================
vsrc2=: 0 : 0
in vec3 vertex;
in vec3 color;
out vec4 v_color;
uniform mat4 mvp;
void main(void)
{
  gl_Position = mvp * vec4(vertex,1.0);
  v_color = vec4(color,1.0);
}
)

fsrc2=: 0 : 0
in vec4 v_color;
void main(void)
{
  gl_FragColor = v_color;
}
)