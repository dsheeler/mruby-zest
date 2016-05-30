Valuator {
    value: 0.6
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color Theme::ScrollInactive
            v.fill
        end
        vg.path do |v|
            v.rect(0,0,self.w*self.value,h)
            v.fill_color Theme::ScrollActive
            v.fill
        end
    }
}
