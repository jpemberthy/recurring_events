# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + "/spec_helper"

describe "English Parser" do
  it "should recognize dates" do
    event = EventParser.parse('El Sr. Falso necesita una visita de 30 minutos los lunes a las 10:00 A.M.')

    event.day.should == :monday
    event.month.should == Time.now.month
    event.year.should == Time.now.year
    event.hour.should == '10:00'

    event = EventParser.parse('El Sr. Falso necesita ayuda medica durante 30 minutos los martes en la mañana')
    event.day.should == :tuesday
    event.month.should == Time.now.month
    event.year.should == Time.now.year
    event.hour.should == '07:00'
  end

  it "should recognize recurrencies" do
    event = EventParser.parse('El Sr. Falso debe ser visitado todos los días en la mañana')
    event.day.should == :all
    event.hour.should == '07:00'
    
    event = EventParser.parse('El Sr. Falso necesita una sopa de pollo todos los días a la hora del almuerzo')
    event.day.should == :all
    event.hour.should == '12:00'

    event = EventParser.parse('El Sr. Falso necesita una visita para jugar bingo los jueves en la noche cada dos semanas')
    event.day.should == :tuesday
    # TODO find some way to specify these recurrencies
  end

  it "should recognize subjects" do
    event = EventParser.parse('El Sr. Falso necesita una visita para jugar bingo los jueves en la noche cada 2 semanas.')
    event.subject.should == 'Sr. Falso'

    event = EventParser.parse('La Sra. Falso necesita uan visita los jueves en la noche todas las semanas')
    event.subject.should == 'Mrs. Jane Fakeworth'
  end

  it "should recognize different event types" do
    event = EventParser.parse('El Sr. Falso necesita una visita de 30 minutes los lunes para darle ayuda medica')
    event.type.should == "ayuda medica"

    event = EventParser.parse('El Sr. Falso necesita una sopa de pollo todos los días en la tarde.')
    event.type.should == "sopa de pollo"
  end

  it "should recognize complete phrases" do
    event = EventParser.parse('El Sr. Falso necesita ayuda medica todos los lunes en la mañana por 30 minutos')

    event.hour.should == '07:00'
    event.day.should == :monday
    event.recurrency.should == :every_week
    event.length.should == "30"
    event.subject.should == 'Mr. Fakedude'
    event.type.should == 'medical support'
    event.month.should == :all
    event.year.should == :all
  end
end
