# encoding: utf-8

#
# autor: Marvin Alfonzo
# clase: Basico::IdiomaController
# descripción: Migración a Rails 3
#

class Basico::IdiomaController < FormTabsController

    
  def index
    list
  end

  
  def list
    params[:sort] = "nombre" unless params[:sort]
    
    @list = Idioma.search("", params[:page], params[:sort])
    @total=@list.count
    form_list
  end
  
  
  def edit
    @idioma = Idioma.find(params[:id])
    @archivo_yml=Rails.root.join('config', 'locales', "#{@idioma.nemonico}.yml")    
  end
  def save_edit
    @idioma = Idioma.find(params[:id])
    
    unless params[:upload].nil? && params[:upload2].nil?
        if @idioma.validates_upload_file(params[:upload],"1")      
          flash[:notice]=nil
          flash[:error]=@idioma
          redirect_to :action=>'edit', :id=>params[:id]                  
        elsif @idioma.validates_upload_file(params[:upload2],"2")
          flash[:notice]=nil
          flash[:error]=@idioma
          redirect_to :action=>'edit', :id=>params[:id]      
        else
          if !params[:upload].nil? && !params[:upload2].nil?                 
              path_to_file=Rails.root.join('config', 'locales', "#{@idioma.nemonico}.yml")
              File.delete(path_to_file) if File.exist?(path_to_file)
              salvado=@idioma.save_archivo(params[:upload2], Rails.root.join('config', 'locales'))
              salvado2=@idioma.save_archivo(params[:upload], Rails.root.join('app','assets','images', 'paises'))
              if salvado && salvado2                  
                  path_to_file=Rails.root.join('app','assets','images', 'paises', "#{@idioma.bandera}")
                  File.delete(path_to_file) if File.exist?(path_to_file)
                  @idioma.activo=params[:idioma][:activo] 
                  @idioma.bandera=params[:upload][:datafile].original_filename.to_s
                  @idioma.save         
                  flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
                  flash[:error]=nil
                  redirect_to :action=>'edit', :id=>params[:id]             
              elsif salvado                  
                  @idioma.activo=params[:idioma][:activo]                   
                  @idioma.save         
                  flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
                  flash[:error]=nil
                  redirect_to :action=>'edit', :id=>params[:id]             
              elsif salvado2
                  path_to_file=Rails.root.join('app','assets','images', 'paises', "#{@idioma.bandera}")
                  File.delete(path_to_file) if File.exist?(path_to_file)
                  @idioma.activo=params[:idioma][:activo] 
                  @idioma.bandera=params[:upload][:datafile].original_filename.to_s
                  @idioma.save         
                  flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
                  flash[:error]=nil
                  redirect_to :action=>'edit', :id=>params[:id]             
              else
                  flash[:notice]=nil
                  flash[:error]=@idioma
                  redirect_to :action=>'edit', :id=>params[:id]                    
              end
          elsif !params[:upload].nil?
              salvado=@idioma.save_archivo(params[:upload], Rails.root.join('app','assets','images', 'paises'))
              if salvado
                  path_to_file=Rails.root.join('app','assets','images', 'paises', "#{@idioma.bandera}")
                  File.delete(path_to_file) if File.exist?(path_to_file)
                  @idioma.activo=params[:idioma][:activo]
                  @idioma.bandera=params[:upload][:datafile].original_filename.to_s 
                  @idioma.save         
                  flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
                  flash[:error]=nil
                  redirect_to :action=>'edit', :id=>params[:id]             
              else
                  flash[:notice]=nil
                  flash[:error]=@idioma
                  redirect_to :action=>'edit', :id=>params[:id]                    
              end
          elsif !params[:upload2].nil?
              path_to_file=Rails.root.join('config', 'locales', "#{@idioma.nemonico}.yml")
              File.delete(path_to_file) if File.exist?(path_to_file)
              salvado2=@idioma.save_archivo(params[:upload2], Rails.root.join('config', 'locales'))
              if salvado2                                    
                  @idioma.activo=params[:idioma][:activo]                   
                  @idioma.save         
                  flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
                  flash[:error]=nil
                  redirect_to :action=>'edit', :id=>params[:id]             
              else
                  logger.debug "ssssss"
                  flash[:notice]=nil
                  flash[:error]=@idioma
                  redirect_to :action=>'edit', :id=>params[:id]                                
              end
          else
              @idioma.activo=params[:idioma][:activo] 
              @idioma.save         
              flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
              flash[:error]=nil
              redirect_to :action=>'edit', :id=>params[:id]             
          end
          
        end
    else
        flash[:notice]=I18n.t('Sistema.Body.General.se_actualizo_con_exito_registro')
        flash[:error]=nil
        @idioma.activo=params[:idioma][:activo]  
        @idioma.save        
        redirect_to :action=>'edit', :id=>params[:id]              
    end
    
    
  end

  def cancel_edit
    @idioma = Idioma.find(params[:id])
    form_cancel_edit @idioma
  end


  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Vistas.Idioma.Header.form_title') 
    @form_title_record = I18n.t('Sistema.Body.Vistas.Idioma.Header.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Vistas.Idioma.Header.form_title_records') 
    @form_entity = 'idioma'
    @form_identity_field = 'nombre'
  end

end
