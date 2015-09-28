
// Description: variables in css
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-04-06 07:17:25 CST
// Last Change: 2013-05-01 16:34:49 CST

import EmacsColors;
from myfunctions access myshipout;

// def var. <<<1

// structs <<<2

struct css_color {
    string name;
    hsv cpen;
}

// in pixels
struct css_size {
    string name;
    real size;
}

// html constants <<<2

//string filename = "/home/ou/archive/site/fweb/pre_css/variables.txt";
string filename = "css/variables.txt";

int home_tabs = 5;

// functions <<<1

// output css color <<<2

void output_color(file fout, css_color color) {

    real[] cs = colors(color.cpen)*255;

    write(fout, color.name + " = rgb(");

    write(fout, (int)(cs[0]+0.5));
    write(fout, ',');
    write(fout, (int)(cs[1]+0.5));
    write(fout, ',');
    write(fout, (int)(cs[2]+0.5));

    write(fout, ')\n');

}

// output css size <<<2

void output_size(file fout, css_size s) {

    write(fout, s.name + " = ");
    write(fout, s.size);
    write(fout, 'px\n');

}

// draw css colors <<<2

void draw_color(css_color color) {

    filldraw(scale(2cm)*unitcircle, color.cpen);
    label(color.name,(0,0));
    myshipout("png","fweb");

}

// define colors <<<1

css_color[] colors;

// body <<<2

css_color color;
color.name = "body-color";
hsv body_color = hsv(0,0,0.4);
color.cpen = body_color;
colors.push(color);

css_color color;
color.name = "body-background-color";
hsv body_bg_color = LightSkyBlue1;
color.cpen = body_bg_color;
colors.push(color);

// main <<<2

css_color color;
color.name = "main-background-color";
hsv main_bg_color = white;
color.cpen = main_bg_color;
colors.push(color);

// table  <<<2

css_color color;
color.name = "table-altrow-bg-color";
color.cpen = hsv(body_bg_color.h, 0.2*body_bg_color.s, body_bg_color.v);
colors.push(color);

// header <<<2

css_color color;
color.name = "header-background-color";
color.cpen = white;
colors.push(color);

// sidebar <<<2

css_color color;
color.name = "sidebar-bg-color";
hsv sidebar_bg_color = hsv(body_bg_color.h, 0.5body_bg_color.s, body_bg_color.v);
color.cpen = sidebar_bg_color;
colors.push(color);

css_color color;
color.name = "sidebar-hover-bg-color";
//color.cpen = sidebar_bg_color + SkyBlue3*0.3;
color.cpen = main_bg_color;
colors.push(color);

css_color color;
color.name = "sidebar-link-color";
hsv sidebar_link_color = body_color;
color.cpen = sidebar_link_color;
colors.push(color);

// tabs <<<2

css_color color;
color.name = "tabs-bg-color";
//hsv tabs_bg_color = hsv(0,0,0.95);
hsv tabs_bg_color = SkyBlue3;
//hsv tabs_bg_color = hsv(body_bg_color.h, 2body_bg_color.s, 3body_bg_color.v);
color.cpen = tabs_bg_color;
colors.push(color);

css_color color;
color.name = "tabs-box-shadow-color";
hsv q = hsv(tabs_bg_color.h,tabs_bg_color.s,0.9*tabs_bg_color.v);
color.cpen = q;
colors.push(color);

css_color color;
color.name = "tabs-hover-bg-color";
color.cpen = tabs_bg_color + SkyBlue3*0.3;
colors.push(color);

// footer <<<2

css_color color;
color.name = "footer-hr-color";
color.cpen = SkyBlue3;
colors.push(color);

// define font size <<<1

css_size[] sizes; 

// body <<<2

css_size size; 
size.name = "body-font-size";
size.size = 14; 
sizes.push(size);

css_size size; 
size.name = "body-line-height";
real body_line_height = 24;
size.size = body_line_height; 
sizes.push(size);

css_size size; 
size.name = "body-min-width";
size.size = 980; 
sizes.push(size);

// main <<<2

css_size size; 
size.name = "main-width";
real main_width = 960; 
size.size = main_width; 
sizes.push(size);

// gallery  <<<2

css_size size; 
size.name = "gallery-img-width";
real gallery_img_width = 200;
size.size = gallery_img_width;
sizes.push(size);

// desc <<<2

css_size size; 
size.name = "desc-width";
size.size = gallery_img_width + 10;
sizes.push(size);

// sidebar <<<2

css_size size; 
size.name = "sidebar-right-left-padding";
real sidebar_rl_pad = 0;
size.size = sidebar_rl_pad; 
sizes.push(size);

css_size size; 
size.name = "sidebar-right-left-margin";
real sidebar_rl_mar = 10;
size.size = sidebar_rl_mar; 
sizes.push(size);

css_size size; 
size.name = "news-right-left-padding";
real news_rl_pad = 20;
size.size = news_rl_pad; 
sizes.push(size);

css_size size; 
size.name = "news-right-left-margin";
real news_rl_mar = 20;
size.size = news_rl_mar; 
sizes.push(size);

css_size size; 
size.name = "sidebar-width";
real sidebar_width = 150;
size.size = sidebar_width; 
sizes.push(size);

css_size size; 
size.name = "news-width";
real news_width = 200;
size.size = news_width; 
sizes.push(size);

css_size size; 
size.name = "news-line-height";
size.size = body_line_height*0.9; 
sizes.push(size);

// content <<<2

css_size size; 
size.name = "content-margin";
real content_margin = 20;
size.size = content_margin; 
sizes.push(size);

css_size size; 
size.name = "content-width";
real content_width = main_width - sidebar_width - 2sidebar_rl_pad - 
    -2*sidebar_rl_mar-2*content_margin - 40; 
size.size = content_width; 
sizes.push(size);

css_size size; 
size.name = "homepage-content-width";
real hp_content_width = main_width - news_width - 2news_rl_pad
    -2*content_margin - 2*news_rl_mar; 
size.size = hp_content_width; 
sizes.push(size);

css_size size; 
size.name = "members-content-width";
real members_content_width = main_width*0.45;
size.size = members_content_width; 
sizes.push(size);

css_size size; 
size.name = "table-img-ico-width";
size.size = content_width/3*0.9; 
sizes.push(size);

// tabs <<<2

css_size size; 
size.name = "tabs-padding";
real tabs_padding = 8; 
size.size = tabs_padding; 
sizes.push(size);

css_size size; 
size.name = "tabs-width";
real tabs_width = (main_width - 2*home_tabs*tabs_padding) / home_tabs;
size.size = tabs_width; 
sizes.push(size);

// output variables <<<1

file fout = output(filename);

write(fout,'# Created by Asymptote script \n');

write(fout,'\n# Colors \n');
for (css_color c : colors) {
    output_color(fout, c);
}

write(fout, '\n# sizes \n');
for (css_size s : sizes) {
    output_size(fout, s);
}

close(fout);
