/*************************************************************************
 *  round_bar.cpp                                                        *
 *************************************************************************
 * The MIT License (MIT)                                                 *
 *                                                                       *
 * Copyright (c) 2015-2017 Gauvain "GovanifY" Roussel-Tarbouriech        *
 * Copyright (c) 2016-2017 António "Keyaku" Sarmento                     *
 * Copyright (c) 2015-2017 SKYNISM                                       *
 *                                                                       *
 * Permission is hereby granted, free of charge, to any person           *
 * obtaining a copy of this software and associated documentation        *
 * files (the "Software"), to deal in the Software without               *
 * restriction, including without limitation the rights to use,          *
 * copy, modify, merge, publish, distribute, sublicense, and/or sell     *
 * copies of the Software, and to permit persons to whom the Software    *
 * is furnished to do so, subject to the following conditions:           *
 *                                                                       *
 * The above copyright notice and this permission notice shall be        *
 * included in all copies or substantial portions of the Software.       *
 *                                                                       *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       *
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES       *
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND              *
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT           *
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                     *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,       *
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE        *
 * USE OR OTHER DEALINGS IN THE SOFTWARE.                                *
 *                                                                       *
*************************************************************************/
#include "round_bar.hpp"

Size2 RoundBar::get_minimum_size() const {

	Ref<StyleBox> bg = get_stylebox("bg");
	Ref<Font> font = get_font("font");

	Size2 ms = bg->get_minimum_size() + bg->get_center_size();
	if (value_visible) {
		ms.height = MAX(ms.height, bg->get_minimum_size().height + font->get_height());
	}
	return ms;
}

void RoundBar::_notification(int p_what) {

	if (p_what == NOTIFICATION_DRAW) {

		Ref<StyleBox> bg = get_stylebox("bg");
		Ref<StyleBox> fg = get_stylebox("fg");
		Ref<Font> font = get_font("font");
		Color font_color = get_color("font_color");

		draw_style_box(bg, Rect2(Point2(), get_size()));
		float r = get_unit_value();
		int mp = fg->get_minimum_size().width;
		int p = r * get_size().width - mp;
		if (p > 0) {

			draw_style_box(fg, Rect2(Point2(), Size2(p + fg->get_minimum_size().width, get_size().height)));
		}

		if (value_visible) {
			String txt = itos(int(get_value())) + " / " + itos(int(get_max()));
			font->draw_halign(get_canvas_item(), Point2(0, font->get_ascent() + (get_size().height - font->get_height()) / 2), HALIGN_CENTER, get_size().width, txt, font_color);
		}
	}
}

void RoundBar::set_value_visible(bool p_visible) {

	value_visible = p_visible;
	update();
}

bool RoundBar::is_value_visible() const {

	return value_visible;
}

void RoundBar::_bind_methods() {

	ObjectTypeDB::bind_method(_MD("set_value_visible", "visible"), &RoundBar::set_value_visible);
	ObjectTypeDB::bind_method(_MD("is_value_visible"), &RoundBar::is_value_visible);
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "percent/visible"), _SCS("set_value_visible"), _SCS("is_value_visible"));
}

RoundBar::RoundBar() {

	set_v_size_flags(0);
	value_visible = true;
}
