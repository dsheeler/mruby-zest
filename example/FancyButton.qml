Widget {
    id: fancy
    property Function whenClick: nil
    property Bool     value:     false
    property Object   valueRef:  nil
    function class_name() { "FancyButton" }

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, fancy.extern)
        fancy.tooltip = meta.tooltip

        fancy.valueRef = OSC::RemoteParam.new($remote, fancy.extern)
        fancy.valueRef.callback = Proc.new {|x| fancy.set_sub_value(x)}
        pow.extern = fancy.extern
        pow.extern()
    }

    function set_value(x)
    {
        self.value = x
        damage_self
    }

    function set_sub_value(x)
    {
        pow.value = x
        damage_self
    }

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function draw(vg)
    {
        grad = if(value)
            bright_green = color("00AE9C")
            dark_green   = color("007368")
            vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        else
            grey1 = Theme::ButtonGrad1
            grey2 = Theme::ButtonGrad2
            vg.linear_gradient(0,0,0,h, grey1, grey2)
        end
        vg.stroke_color color("000000", 0xa0)
        vg.path do |v|
            v.rounded_rect(0,0,w/4,h, 5)
            v.fill_paint(grad)
            v.fill
            v.stroke_width 1
            v.stroke
        end

        grey1 = Theme::ButtonGrad1
        grey2 = Theme::ButtonGrad2
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            pad = 0
            v.rounded_rect(w/4+pad,0,w*3/4,h, 3)
            if(value)
                v.fill_paint grad
            else
                v.fill_paint grad2
            end
            v.fill
            v.stroke
        end

        text_color1   = Theme::TextActiveColor
        text_color2   = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*0.6
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w*1.25/2,h/2,label.upcase)
    }

    function onMousePress(ev) {
        #self.value = !self.value
        #damage_self
        valueRef.value = true if(value == false && valueRef)
        whenClick.call if whenClick
    }

    function layout(l,selfBox)
    {
        box = pow.fixed(l, selfBox, 0, 0, 0.25, 1)
        if(layoutOpts.include? :no_constraint)
            box.w = 0
            box.y = 0
            box.w = 0.25*selfBox.w
            box.h = selfBox.h
        end
        selfBox
    }

    PowButton {
        id: pow
        function class_name() { "PowButton" }
    }

}
