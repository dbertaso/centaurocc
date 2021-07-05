# encoding: UTF-8

#
# autor: Marvin Alfonzo
# clase: Basico::CuentaBcvController
# descripción: Migración a Rails 3
#

class Basico::CuentaBcvController < FormClassicController
	
  def list
    
    params['sort'] = "entidad_financiera.nombre" unless params['sort']
     conditions =""
     
    unless params[:numero].nil? || params[:numero].blank?
      unless params[:numero]==''
        conditions = ["numero LIKE ?", "%"<<params[:numero].to_s.strip.downcase << "%"]      
        @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.numero_igual')} '#{params[:numero]}'"		
      end
    end
    
    
		unless params[:entidad_financiera_id].nil? || params[:entidad_financiera_id].blank?
		  unless params[:entidad_financiera_id][0]==""
        conditions = ["entidad_financiera_id = ?", params[:entidad_financiera_id][0].to_s.to_i]
  			@form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.entidad_financiera_igual')} '#{EntidadFinanciera.find(params[:entidad_financiera_id][0]).nombre}'"		  
      end
		end    
        

   @list = CuentaBcv.search(conditions, 
                            params[:page], 
                            params['sort'])
    @total=@list.count

    form_list

  end

  def index
     fill_entidad_financiera
  end
 
  def new
    fill_entidad_financiera
    @cuenta_bcv = CuentaBcv.new
  end

  def save_new
     @cuenta_bcv = CuentaBcv.new(params[:cuenta_bcv])
    form_save_new @cuenta_bcv
  end
  
  def delete
     @cuenta_bcv = CuentaBcv.find(params[:id])
    form_delete @cuenta_bcv
  end
  
  def edit
    fill_entidad_financiera
     @cuenta_bcv = CuentaBcv.find(params[:id])
  end
  
  def view
     @cuenta_bcv = CuentaBcv.find(params[:id])
  end
  
  def save_edit
     @cuenta_bcv = CuentaBcv.find(params[:id])
    form_save_edit @cuenta_bcv
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.CuentaBcv.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.CuentaBcv.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.CuentaBcv.FormTitles.form_title_records')
    @form_entity = 'cuenta_bcv'
    @form_identity_field = 'numero'
    @width_layout = '800'
  end
  
  private
  def fill_entidad_financiera
   @entidad_financiera_list = EntidadFinanciera.find(:all, :order=>'nombre',:conditions=>"activo=true")      
  end

end
