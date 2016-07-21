Widget {
    property String extern: ""
    property Array  options: ["text", "test", "asdf"];
    property Int    selected: 0
    property Function whenValue: nil

    function set_value_user(val) {
        whenValue.call if whenValue
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, self
        if(!layoutOpts.include?(:no_constraint))
            scale = 100
            $vg.font_size scale
            bb = 1
            self.options.each do |x|
                x = x[0..8] if x.length > 8
                bbl  = $vg.text_bounds(0, 0, (x+"    ").upcase)
                bb   = [bb, bbl].max
            end
            scale *= layoutOpts[0] if layoutOpts.include?(:rescale)
            if(bb != 0)
                #Width cannot be so small that letters overflow
                l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
            end
        end
        selfBox
    }

    function class_name()
    {
        "Menu"
    }

    function onMousePress(ev)
    {
        create_menu
    }

    function draw(vg)
    {
        text_color = Theme::TextColor
        pad  = 1/64
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(w*pad, h*pad, w*pad2, h*pad2)
            paint = v.linear_gradient(0,0,0,h,
            Theme::ButtonGrad1, Theme::ButtonGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.path do |v|
            tx = w*pad2-h*pad2
            tw = h*pad2
            ty = h*pad
            th = h*pad2

            v.move_to(tx+0.25*tw, ty+0.3*th)
            v.line_to(tx+0.50*tw, ty+0.7*th)
            v.line_to(tx+0.75*tw, ty+0.3*th)
            v.close_path

            v.fill_color Theme::TextColor
            v.fill
        end
        return if options[selected].nil?

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color text_color
        vg.text(3+w*pad*2,h/2,label.upcase)
    }

    function create_menu()
    {
        n = options.length
        widget = DropDown.new(self.db)
        widget.w = self.w
        widget.h = self.h*n
        widget.x = 0
        widget.y = 0
        widget.layer = 2
        widget.options = options
        widget.callback = lambda { |v|
            set_value_user(v)
        }
        print "widget.x = "
        puts widget.x
        widget.y = -self.h*(n-1) if(widget.h+global_y > window.h)

        Qml::add_child(self, widget)
        root.smash_draw_seq
        root.damage_item widget
    }

}