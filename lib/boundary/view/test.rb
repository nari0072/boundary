# -*- coding: utf-8 -*-
=begin
るびまの日の丸描画サンプルをSVG形式での保存に変更してみた
基本的な流れはほとんど同じ。素晴らしい
http://jp.rubyist.net/magazine/?0019-cairo
=end
require 'cairo'

p "hello"
#format = Cairo::FORMAT_ARGB32
width = 300
height = 200
radius = height / 3

#保存ファイル名を含めたsufeceとcontextの生成
surface = Cairo::SVGSurface.new("hoge.svg", width, height)
#surface = Cairo::ImageSurface.new(format, width, height)
context = Cairo::Context.new(surface)

#背景の白
context.set_source_rgb(0.9, 0.9, 1)
context.rectangle(0, 0, width, height)
context.fill

context.set_source_rgb(1, 0, 0)
context.arc(width / 2, height / 2, radius, 0, 2 * Math::PI)
context.fill

#SVGだと順次保存されるので必要ない
surface.write_to_png("hinomaru.png")
