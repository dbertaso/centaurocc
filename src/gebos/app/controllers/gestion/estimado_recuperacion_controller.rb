# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Gestion::EstimadoRecuperacionController
# descripción: Migración a Rails 3

## require 'ziya'

require 'rubygems'

class Gestion::EstimadoRecuperacionController < FormTabsController

  layout 'form_basic'

  def index

        #intereses
        
		@_30diasint = PlanPagoCuota.sum('interes_corriente', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 30]) +
		              PlanPagoCuota.sum('interes_diferido', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 30])
		              
		@_60diasint = PlanPagoCuota.sum('interes_corriente', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 60]) +
		              PlanPagoCuota.sum('interes_diferido', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 60])
		
		@_90diasint = PlanPagoCuota.sum('interes_corriente', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 90]) +
		              PlanPagoCuota.sum('interes_diferido', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 90])
		              
		@_180diasint = PlanPagoCuota.sum('interes_corriente', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 180]) +
		               PlanPagoCuota.sum('interes_diferido', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 180])
		               
		@_anioint = PlanPagoCuota.sum('interes_corriente', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.new(Date.today.year, 12, 31)]) +
		            PlanPagoCuota.sum('interes_diferido', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.new(Date.today.year, 12, 31)])

        #capital
        
		@_30diascap = PlanPagoCuota.sum('amortizado', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 30])
		@_60diascap = PlanPagoCuota.sum('amortizado', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 60])
		@_90diascap = PlanPagoCuota.sum('amortizado', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 90])
		@_180diascap = PlanPagoCuota.sum('amortizado', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 180])
		@_aniocap = PlanPagoCuota.sum('amortizado', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.new(Date.today.year, 12, 31)])

        #cuota
        
		@_30dias = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 30])
		@_60dias = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 60])
		@_90dias = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 90])
		@_180dias = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.today + 180])
		@_anio = PlanPagoCuota.sum('valor_cuota', :conditions=>["fecha > ? and fecha < ? ", Date.today, Date.new(Date.today.year, 12, 31)])

  end
    
  protected  
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.EstimadoRecuperacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.EstimadoRecuperacion.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.EstimadoRecuperacion.FormTitles.form_title_records')
    @form_entity = ''
    @form_identity_field = ''
    @width_layout = 900;
  end

end

