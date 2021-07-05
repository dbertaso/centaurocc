Gebos::Application.routes.draw do


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'inicio#login'

  match 'sesion', :to => 'inicio#sesion'
  match 'login', :to => 'inicio#login'
  match 'logout', :to => 'inicio#logout'

  namespace :basico do

    resources :abogado do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end
    #====> Fin resources :abogado do
    
    resources :analista_cobranzas do

      collection do
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :check_ci_new
        get :sector_change
        get :sector_search
        get :sub_sector_change
        get :sub_sector_search
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end    #----> Fin resources :analista_cobranzas do
    
    resources :ayuda do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end
    #====> Fin resources :ayuda do
    
    
    resources :arte_pesca do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :tipo_arte_pesca_change
      end

      member do
        post :save_edit
        post :delete
        post :new
      end
    end

    resources :clase do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    
    resources :causales_anulacion_revocatoria do

      collection do
        get :list
        post :list
        post :save_new
        get :edit
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :new
      end

    end
    #====> Fin resources :causales_anulacion_revocatoria do
    
    resources :convertidor do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end


    resources :embarcacion do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
        post :delete
        get :proveedor_click
        get :imprimir_sector
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
        get :view
      end

    end         #====> Fin resources :embarcacion do
    
    resources :equipo_seguridad do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end
    end

    resources :condiciones_financiamiento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :programa_search
        get :programa_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :sector_search
        get :sub_sector_search
        get :rubro_search
        get :sub_rubro_search
        get :view
      end

      member do
        post :save_edit
        post :delete
        post :edit
        get :view
        get :programa_search
        get :programa_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :sector_search
        get :sub_sector_search
        get :rubro_search
        get :sub_rubro_search
      end
    end       #----> Fin resources :detalle_precio_gaceta

    resources :hierro_fondas do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :calendar
      end

      member do
        post :save_edit
        post :delete
        post :edit
        get  :estado_change
        get  :calendar
      end

    end         #====> Fin resources :hierro_fondas do
    
    resources :faenas_pesca do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
      end

      member do
        post :save_edit
        post :edit
        post :new
        post :delete
      end
    end

    resources :formacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end         #====> Fin resources :formacion do

    resources :imputaciones_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        get :view
      end

    end         #====> Fin resources :imputaciones_maquinaria do
    
    resources :imputaciones_internacional do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        get :view
      end

    end         #====> Fin resources :imputaciones_maquinaria do

    resources :instrumento_financiero do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end   # Fin :instrumento_financiero

    resources :riesgo_institucion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end   # Fin :riesgo_institucion

    resources :riesgo_sudeban do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end   # Fin :riesgo_sudeban 

    resources :garantia_sector do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
        get :view
        get :sector_change
        post :edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        get :view
        get :sector_change
      end

    end         #====> Fin resources :garantia_sector do

    resources :marca_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :marca_maquinaria do

    resources :miembro_comite do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :miembro_comite do


    resources :modalidad_financiamiento do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :modalidad_financiamiento do

    resources :modelo do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :modelo do
    
    resources :motores do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :proveedor_click
      end

      member do
        post :save_edit
        post :new
        post :delete
      end
    end

    resources :nacionalidad do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :nacionalidad do
    
    resources :nemonico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :mensajes_correo do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :mensajes_correo do

    resources :mensajes_sms do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :mensajes_sms do

    resources :motivos_atraso do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :motivos_atraso do

    resources :origen_fondo do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :edit
      end

    end         #====> Fin resources :origen_fondo do

    resources :pais do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :cancel_new
        post :cancel_edit
        post :edit
      end

    end       #====> Fin resources :pais do


    resources :firma_autorizada do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :firma_autorizada do


    resources :almacen_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
      end

      member do
        get :edit
        post :save_edit
        post :save_new
        post :delete
      end

    end
    
    resources :almacen_maquinaria_sucursal do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
      end

      member do
        get :edit
        post :save_edit
        post :save_new
        post :delete
      end

    end

    resources :precio_gaceta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :precio_gaceta


    resources :caso_medida do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
        post :edit
      end
    end       #----> Fin resources :caso_medida

    resources :detalle_precio_gaceta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :detalle_precio_gaceta

    resources :casa_proveedora do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :casa_proveedora

    resources :sucursal_casa_proveedora do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :region_search
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :sucursal_casa_proveedora do

    resources :analisis_topico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :analisis_topico do

    resources :vacuna do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :vacuna do

    resources :vocacion_tierra do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :vocacion_tierra do

    resources :tipo_especie_acuicultura do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :tipo_especie_acuicultura do

    resources :tipo_sistema_cultivo_acuicultura do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :tipo_sistema_cultivo_acuicultura do

    resources :tipo_arte_pesca do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end       #----> Fin resources :tipo_arte_pesca do

    resources :tipo_equipo_seguridad do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end       #----> Fin resources :tipo_equipo_seguridad do

    resources :contrato_maquinaria_equipo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :contrato_maquinaria_equipo do

    resources :cuenta_bcv do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :cuenta_bcv do

    resources :eje do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :region do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :estado do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :region_search
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :estado

    resources :estado_ciudad do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :estado_ciudad do

    resources :estado_municipio do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :estado_municipio do

    resources :municipio_parroquia do

      collection do
        get :list
        post :list
        post :save_new        
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :municipio_parroquia do

    resources :empresa_transporte_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :estado_change
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :edit
        post :save_edit
        post :delete
      end

    end     #----> Fin resources :empresa_transporte_maquinaria do


    resources :entidad_financiera do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :entidad_financiera


    resources :especie_variedad_pasto do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end #----> Fin resources :especie_variedad_pasto

    resources :experiencia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end #----> Fin resources :experiencia

    resources :ciclo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end #----> Fin resources :ciclo

    resources :sector do

      collection do
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :sector do

    resources :silo do

      collection do
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end    #----> Fin resources :silo do

    resources :empleado_silo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :list
        post :save_edit
        post :delete
        get :view
      end
    end    #----> Fin resources :empleado_silo do

    resources :acta_silo do

      collection do
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end    #----> Fin resources :acta_silo do
    
    resources :condicion_sacos do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
        post :list
      end
    end    #----> Fin resources condicion_sacos
    
    resources :convenio_silo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :list
        post :save_edit
        post :delete
        get :view
      end
    end    #----> Fin resources :convenio_silo do
    
    resources :detalle_convenio_silo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end

      member do
        post :list
        post :save_edit
        post :delete
        get :view
      end
    end    #----> Fin resources :detalle_convenio_silo do

    resources :programa do

      collection do
        post :list
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :tipo_credito_change
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        post :tipo_credito_change
      end

    end     #----> Fin resources :programa do

    resources :programa_origen_fondo do

      collection do
        get :list
        get :index
        post :new
        post :save_new
        post :cancel_new
        post :cancel_edit
        get :edit
      end

      member do
        post :list
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        post :new
      end

    end     #----> Fin resources :programa_origen_fondo do

    resources :programa_garantia do

      collection do
        get :list
        post :save_new
        post :cancel_new
        post :cancel_edit
        get :recaudo_list
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        get :recaudo_list
        post :new
      end

    end     #----> Fin resources :programa_garantia do

    resources :programa_gasto do

      collection do
        post :list
        get :list
        post :save_new
        post :cancel_new
        post :cancel_edit
        get :recaudo_list
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        get :recaudo_list
        post :new
        post :list
        #post :cancel_new
      end

    end     #----> Fin resources :programa_garantia do

    resources :programa_producto do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :producto_list
        post :sector_change
        post :permitir_abonos_change
        post :meses_gracia_si_change
        post :meses_muertos_si_change
      end

      member do
        post :list
        post :save_edit
        post :save_new
        post :delete
        get :view
        get :producto_list
        post :sector_change
        post :permitir_abonos_change
        post :meses_gracia_si_change
        post :meses_muertos_si_change
      end

    end     #----> Fin resources :programa_producto do

    resources :programa_producto_formula do

      collection do
        #get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :recaudo_list
      end

      member do
        post :save_edit
        post :save_new
        post :cancel_new
        post :delete
        post :edit
        post :new
        get :view
        post :list
      end

    end     #----> Fin resources :programa_producto do

    resources :programa_tipo_cliente do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
        get :tipo_cliente_list
        post :new
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        post :tipo_cliente_list
        post :new
        get :list
      end

    end     #----> Fin resources :programa_tipo_cliente

    resources :programa_modalidad_financiamiento do

      collection do
        get :list
        post :list
        get :_list
        post :save_new
        post :cancel_new
        post :cancel_edit
        post :modalidad_financiamiento_list
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
        get :view
        post :new
        post :modalidad_financiamiento_list
      end

    end     #----> Fin resources :programa_modalidad_financiamiento do

    resources :parametro_general do

      collection do
        get :list

      end

      member do
        post :save_edit
        post :edit
      end

    end     #----> Fin resources :programa_garantia do

    resources :idioma do

      collection do
        get :list
        post :list       

      end

      member do
        post :save_edit
        post :edit
        
      end

    end     #----> Fin resources :idioma do


    resources :tasa do

      collection do
        get :list
        get :sector_tasa_change
        get :sector_tasa_change_list
        get :sub_sector_tasa_change
        get :sub_sector_tasa_change_list
        get :rubro_tasa_change
        get :rubro_tasa_change_list
        get :_list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        get :view
        get :sector_tasa_change
        get :sector_tasa_change_list
        get :sub_sector_tasa_change
        get :sub_sector_tasa_change_list
        get :rubro_tasa_change
        get :rubro_tasa_change_list
        post :save_edit
        post :save_new
        post :delete
        post :edit
        post :new
      end

    end     #----> Fin resources :tasa do

    resources :tasa_valor do

      collection do
        get :list
        get :_list
        get :tasa_valor_list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
      end

      member do
        get :view
        get :tasa_valor_list
        post :save_edit
        post :save_new
        post :delete
        post :edit
        post :new
      end

    end     #----> Fin resources :tasa_valor do

    resources :rubro do

      collection do
        get :list
        get :index
        post :save_edit
        post :save_new
        #get :new
      end

      member do
        post :list
        post :save_edit
        post :save_new
        get :cancel_new
        get :cancel_edit
        post :delete
        post :edit
      end

    end     #----> Fin resources :rubro do

    resources :sub_sector do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :sub_sector do

    resources :sub_rubro do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :sub_rubro do

    resources :cronograma_desembolso do

      collection do
        get :list
        get :cancel_new
        get :cancel_edit
        post :list
        post :save_new

      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :cronograma_desembolso do

    resources :actividad do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
      end

      member do
        get :list
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :actividad do

    resources :actividad_activar do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :actividad_activar do

    resources :partida do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :partida do

    resources :item do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :item do

    resources :item_atributo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
      end

      member do
        get :edit
        get :cancel_edit
        post :save_edit
        post :save_new
        post :delete
        post :edit
      end

    end     #----> Fin resources :item_atributo do

    resources :carga_masiva do

      collection do
        get :list
        post :list
        post :save_new
        post :create
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :catalogo do

      collection do
        get :almacen_search
        get :clase_form
        get :list
        post :list_especial
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :contrato_change
        get :clase_search
        get :municipio_change
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :causa_devolucion_cliente do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end     #----> Fin resources :causa_devolucion_cliente do

    resources :causa_diferimiento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :causa_rechazo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :causa_renuncia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :configuracion_avance do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :configuracion_reverso do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :comunidad_indigena do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :condicion_pasto do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :condiciones_analisis_credito do

      collection do
        post :save_edit
        post :save_new
        get :cancel_new
      end

      member do
        get :cancel_new
      end
    end

    resources :configuracion_existencia do

      collection do
        get :list
        post :list
        post :save_new
        get :clase_search
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :estatus do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :estructura_costo do

      collection do
        get :list
        post :list
        post :save_new
        get :clase_search
        get :cancel_new
        get :estado_change
        get :estado_select
        get :estado_up_select
        get :sector_list
        get :sub_sector_list
        get :rubro_list
        get :sub_rubro_list
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :actividad_change
      end

      member do
        post :save_edit
        post :delete
      end
    end
    
    
    
    resources :formato_boleta do
      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        post :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
      member do
        post :save_edit
        post :delete
      end
    end  #----> Fin resources formato_boleta


    resources :instancia_comite_nacional do


      collection do
        get :list
        post :list
        post :list_miembro_view
        post :list_miembro
        get :list_miembro_view
        get :list_miembro
        post :tabs
        post :form_punto_cuenta_view
        post :form_datos_basicos_view
        post :save_new        
        get :delete_miembro
        get :cancel_new
        get :cancel_form
        get :cancel_edit
        get :save_comite
        get :view
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :instancia_comite_estadal do

      collection do
        get :list
        post :list
        post :save_new
        get :save_comite
        get :cancel_new
        get :cancel_form
        get :cancel_edit
        get :view
        get :agregar_miembro
        get :delete_miembro
        post :tabs
        post :form_punto_cuenta_view
        post :form_datos_basicos_view
        post :list_miembro_view
        post :list_miembro
        get :save_comite
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :analisis_conclusion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :moneda do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :marca do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :motivo_visita do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :partida_presupuestaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :perito do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :porcentaje_ganancia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :profesion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :proveedor_marino do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :recaudo do

      collection do
        get :list
        post :list
        post :save_new
        get :sector_change
        get :clase_search
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :sector_tecnico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end    #----> Fin resources :sector_tecnico

    resources :rol_comite do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :sitio_colocacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :tecnico_campo do

      collection do
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :check_ci_new
        get :estado_change_index
        get :oficina_change
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end    #----> Fin resources :tecnico_campo do

    resources :tenencia_unidad_produccion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :tipo_cliente_juridico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_cliente_natural do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_credito do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_documento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_drenaje do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :tipo_embarcacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :tipo_explotacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :tipo_fuente_agua do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_garantia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_gasto do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_infraestructura do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_iniciativa do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_material do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_motor do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_nylon do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_pasto_forraje do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_riego do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipos_semovientes do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_suelo do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_topografia do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :tipo_vialidad do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end
      member do
        post :save_edit
        post :delete
      end
    end

    resources :unidad_medida do

      collection do
        get :list
        post :list
        post :save_new
        post :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :edit
        post :cancel_edit
        post :cancel_new
      end
    end       #====> fin resources :unidad_medida do

  end

  namespace :cobranzas do

    resources :agregar_cobranzas do

      collection do

        get :list
        post :list
        get :asignado
      end

      member do

        get :view
        get :asignado
      end

    end     #Fin resources agregar_cobranzas

    resources :consulta_cobranzas do

      collection do
      end

      member do
        get :index
      end

    end

    resources :gestion_cobranzas do

      collection do

        #get :save_new
        post :exigible_change
        post :fecha_limite
        get :verifica_compromiso
        get :email_change
        get :sms_change
        get :mostrar_llamada
      end

      member do


        get :email_change
        get :sms_change
        get :save_otro
        get :verifica_compromiso
        get :mostrar_llamada
        post :telecobranzas_save
        post :exigible_change
        post :save_new
      end

    end     #Fin resources gestion_cobranzas

    resources :historico_cobranzas do

      collection do

        get :expand
        get :colapsar
        get :list
        get :consultar
        post :list

      end

      member do

        get :consultar
        get :telecobranzas
        get :email
        get :sms

      end

    end     #Fin resources historico_gestion_cobranzas

    resources :reporte_indicadores_analista do

      collection do
        get :reporte
        post :reporte
      end

      member do
        get :reporte
        post :reporte
      end
    end

  end       #Fin namespace cobranzas
  
  namespace :consultas do
    
    resources :consulta_inventario do

      collection do
        get :clase_search
        get :list
        post :list
        get :expand
        get :view
      end
    end
    
    resources :consulta_stock do

      collection do
        get :clase_search
        get :list
        post :list
        get :expand
        get :reporte
        get :view
      end
    end
    
  end #Fin namespace consultas

  namespace :contabilidad do

    resources :consultar_comprobante do

      collection do
        get :list
        post :list
        get :expand
        get :collapse
        get :list_asiento
        post :list_asiento
      end
    end

    resources :cuenta_contable do

      collection do
        post :list
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :index
      end

      member do
        post :save_edit
        post :delete
        post :edit
        get :view
      end

    end 

    resources :regla_contable do

      collection do
        get :list
        post :list
        post :save_new
        post :edit
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
        post :edit
        get :edit
      end

    end

    resources :reporte_contabilidad do

      collection do
        get :reporte
        post :reporte
      end

      member do
        get :reporte
        post :reporte
      end
    end

    resources :envio_asiento_contable do

      collection do
        get :enviados
        post :enviados
        get :consulta_envio
        get :consulta_rechazos
      end
    end

    resources :transaccion_contable do

      collection do
        post :list
        get :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :index
      end

      member do
        post :save_edit
        post :delete
        post :edit
        get :view
      end

    end 
  end
  
  namespace :gestion do

    resources :edad_mora do

      collection do
        get :agrupador_change
        get :region_change
        get :rubro_change
        get :sector_change
        get :sub_rubro_change
        get :sub_sector_change
        get :moneda_change
        get :index
      end

      member do

        get :region_change
        get :rubro_change
        get :sector_change
        get :sub_rubro_change
        get :sub_sector_change

      end
    end

    resources :estimado_recuperacion do

      collection do
        get :index
      end
    end

    resources :indicador_cartera do

      collection do
        get :agrupador_change
        get :region_change
        get :rubro_change
        get :sector_change
        get :sub_rubro_change
        get :sub_sector_change
        get :moneda_change
        get :index
      end

      member do

        get :region_change
        get :rubro_change
        get :sector_change
        get :sub_rubro_change
        get :sub_sector_change

      end
    end

    resources :indicador_global do

      collection do
        get :index
      end
    end


  end
  namespace :sistema do

    resources :autorizacion_aprobacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
        get :imprimir
        get :aprobar
        get :rechazar
      end

      member do
        post :save_edit
        post :delete
      end
    end #del autorizacion_aprobacion

    resources :autorizacion_solicitud do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
        get :imprimir
      end

      member do
        post :save_edit
        post :delete
      end
    end #del autorizacion_solicitud

    resources :usuario_clave do

      collection do
        get :index
        post :save_edit
      end

    end

    resources :consultar_transaccion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        post :solicitar_autorizacion
        post  :reversar
        post :expand
        post :collapse
        post :expand_accion
        post :collapse_accion
        get :opcion_list
      end

      member do
        post :save_edit
        post :delete
        post :solicitar_autorizacion

      end
    end #del consultar_transaccion

    resources :departamento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end
    end
    
    resources :empresa_sistema do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
      end

      member do
        post :save_edit
        post :delete
      end

    end

    resources :oficina do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :oficina_area do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :olvido_clave do

      collection do
        get :index
        post :save_edit
      end

    end
    
    resources :opcion_accion_autorizacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
        get :imprimir
      end

      member do
        post :save_edit
        post :delete
      end
    end # opcion_accion_autorizacion

    resources :rol do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :imprimir
      end

      member do
        post :save_edit
        post :delete
      end
    end #del Rol

    resources :rol_opcion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :imprimir
        get :opcion_grupo_change
        get :opcion_change
        post :expand
        post :collapse
        get :opcion_list
      end

      member do
        post :save_edit
        post :delete
      end
    end #del rol_opcion

    resources :usuario do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :view
        get :imprimir
        get :locate_change
      end

      member do
        post :save_edit
        post :delete
      end
    end #del  usuario

    resources :usuario_rol do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :list_view
        post :new
      end

      member do
        post :save_edit
        post :delete
      end
    end #del namespace usuario_rol

    resources :cambiar_clave do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :list_view
      end

      member do
        post :save_edit
        post :delete
      end
    end #del namespace cambiar_clave

  end # del namespace sistema

  namespace :clientes do

    resources :cliente_empresa do

      collection do
        get :list
        post :list
        post :save_new
        post :check_new
        get :cancel_new
        get :cancel_edit
        get :region_search
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
        get :printer
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end

    resources :cliente_empresa_direccion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :region_change
        get :sub_sector_change
        get :municipio_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_direccion_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_email do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_integrante_persona do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        post :check_new
        get :estado_change
        get :region_change
        get :sub_sector_change
        get :municipio_change
        get :sub_rubro_change
        get :vinculo
        get :vinculo_view
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_integrante_persona_direccion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :region_change
        get :sub_sector_change
        get :municipio_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_integrante_persona_direccion_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :region_change
        get :sub_sector_change
        get :municipio_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_integrante_persona_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
      end
    end

    resources :cliente_empresa_integrante_persona_email do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
      end
    end

    resources :cliente_empresa_unidad_produccion do

      collection do
        get :list
        post :list
        post :save_new
        post :delete_utm
        post :save_new_utm
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view_detail
        get :region_change
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_registro do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_empresa_cuenta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :detalles_cambios_cuenta
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_persona do

      collection do
        get :list
        post :list
        post :save_new
        post :check_new
        get :cancel_new
        get :cancel_edit
        get :region_search
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
        get :printer
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :cliente_persona do

    resources :cliente_persona_direccion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :region_change
        get :sub_sector_change
        get :municipio_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_direccion

    resources :cliente_persona_direccion_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

    resources :cliente_persona_telefono do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_telefono

    resources :cliente_persona_email do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_email

    resources :cliente_persona_unidad_produccion do

      collection do
        get :list
        post :list
        post :save_new
        post :delete_utm
        post :save_new_utm
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view_detail
        get :region_change
        get :estado_change
        get :municipio_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_unidad_produccion

    resources :cliente_persona_registro do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view_detail
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_registro

    resources :cliente_persona_cuentas do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :detalles_cambios_cuenta
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :cliente_persona_cuentas

    resources :cliente_persona_cuentas do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :edit_validate
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end

  end # del namespace clientes

  namespace :presupuesto do

    resources :presupuesto_pidan do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_index_form_change
        get :sub_sector_index_form_change
        get :sub_rubro_index_form_change
        get :sector_change
        get :programa_change
        get :rubro_change
        get :rubro_change_destino
        get :rubro_change_origen
        get :sector_tra_orig_change
        get :sector_tra_dest_change
        get :sector_form_change
        get :edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end

  end # del namespace presupuesto_pidan


  namespace :maquinaria do

    resources :envio_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :municipio_change        
        get :edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end # del envio_maquinaria

    resources :recepcion_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit        
        get :deshacer
        get :imprimir_recepcion
        get :cerrar
        get :edit
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end # del recepcion_maquinaria  
  
  
    resources :guia_movilizacion_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :enviar
        get :destino_change        
        get :edit
        get :view
        get :view_maquinaria
        get :printer
      end

      member do
        post :save_edit
        post :new
        post :delete
      end

    end # del guia_movilizacion_maquinaria
  
  
  
  end # del namespace maquinaria


  namespace :solicitudes do

    
    resources :asignar_maquinaria do

      collection do
        get :asignar
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :avanzar
        get :asignar_catalogo
        get :estado_change
        get :municipio_change
        get :clase_search
        get :plan_inventario
        get :sras
      end

      member do
        post :save_edit
        post :delete
        post :change_serial
      end
    end       #----> Fin resources :asignar_maquinaria
    
    resources :plan_inventario do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit 
        get :list_catalogo_asignado
        get :asignar_catalogo
        get :delete       
        get :clase_search
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :plan_inventario
    
    
    resources :liquidacion_maquinaria_equipo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :generar_tabla
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :liquidacion_maquinaria_equipo
    
    
    resources :consulta_orden_despacho do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view        
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :consulta_orden_despacho
    
    resources :comite_nacional do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
        get :decision_comite_nacional
        get :rubro_search
        get :subsector_search
        get :sub_rubro_change
        get :rubro_change
        get :sub_sector_change
        get :sector_change
        get :resumen_comite_solicitud
        post :decision_comite
        get :decision_comite
        get :reversar
        get :hide_reversar
        get :new_observar
        get :new_reversar
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :comite_nacional

    resources :comite_estadal do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
        get :decision_comite_estadal
        get :rubro_search
        get :subsector_search
        get :sub_rubro_change
        get :rubro_change
        get :sub_sector_change
        get :sector_change
        get :sub_sector_form_change
        get :resumen_comite_solicitud
        post :decision_comite
        get :decision_comite
      end

      member do
        post :save_edit        
        post :delete
      end
    end       #----> Fin resources :comite_estadal

    resources :comite_resumen do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
        get :numero_sesion_search
        get :subsector_search
        get :rubro_search
        get :reseteo_combos
        get :decision_comite_nacional
        get :generar_resumen_decision_excel
        get :generar_resumen_sesion
        get :generar_detalle_financiamiento
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :comite_resumen
    
    resources :solicitud_consulta_desembolsos do

      collection do
        get :list
        post :list
        get :view
      end

    end

    resources :solicitud_consultoria_juridica do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :sector_change
        get :condiciones_vegetal_y_forestal
        get :condiciones_animal
        get :sector_form_change
        get :sub_sector_change
        get :sub_sector_form_change
        get :rubro_change
        get :rubro_form_change
        get :sub_rubro_change
        get :sub_rubro_form_change
        get :generar
        get :acta_entrega
        get :generar_NA
        get :avanzar
        get :abogado
        get :fecha_acta
        get :sras
        get :condiciones
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :solicitud_consultoria_juridica

    resources :solicitud_consultoria_juridica_historico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :sector_change
        get :sector_form_change
        get :sub_sector_change
        get :sub_sector_form_change
        get :rubro_change
        get :rubro_form_change
        get :sub_rubro_change
        get :sub_rubro_form_change
        get :generar
        get :print_acta_entrega
        get :suscribir
        get :acta_entrega
        get :generar_NA
        get :avanzar
        get :abogado
        get :fecha_acta
        get :sras
        get :condiciones
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :solicitud_consultoria_juridica_historico

    resources :solicitud_testigos do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :solicitud_testigos

    resources :consulta_ciclo_productivo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :liberar_grupo
        get :liberar_solicitud
        get :view
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :consulta_ciclo_productivo

    resources :consulta_certificacion_presupuestaria do

      collection do
        get :list
        post :list        
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
        get :liberar
      end

      member do
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :consulta_certificacion_presupuestaria

    resources :consulta_evaluacion_credito do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :avanzar
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :consulta_evaluacion_credito do



    resources :consulta_fideicomiso do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :liberar_solicitud
        get :sub_rubro_form_change
        get :sub_rubro_change
        get :rubro_form_change
        get :rubro_change
        get :sub_sector_form_change
        get :sub_sector_change
        get :sector_form_change
        get :sector_change
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end
    end       #----> Fin resources :consulta_fideicomiso do

    resources :consulta_fideicomiso_historico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :export
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :consulta_fideicomiso_historico do


    resources :consulta_solicitud do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :consulta_solicitud do

    resources :solicitud_evaluacion_asignacion do

      collection do
        get :actualizar
        get :list
        post :list
        post :save_observaciones
        post :save_reasignar
        get :save
        get :municipio_change
        get :re_asignar_maxiva
        get :reversar
        get :save_revisado
        get :cancel_new
        get :cancel_edit
        post :save_re_asignar_maxivo
        get :view
      end

      member do
        post :edit
        get :new_reversar
        get :asignar
        get :reasignar
        post :save_asignar
        get :rechazar
      end

    end

    resources :deshacer do

      collection do
        get :reversar
      end

      member do
        get :new_deshacer
        post :deshacer
      end

    end

    
    resources :decision do

      collection do
        get :edit
        get :list
        post :list
        post :save_new
        post :save_edit
        get :viable_click
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        post :new
        post :delete
      end

    end

    resources :reversar do

      collection do
        get :reversar
        post :reversar
      end

      member do
        get :new_reversar
        get :hide_reversar
      end

    end

    resources :solicitud_consulta_evento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end

    resources :solicitud_recaudo do

      collection do
        get :actualizar
        get :list
        post :list
        post :save_observaciones
        get :save
        get :save_revisado
        get :cancel_new
        get :cancel_edit
        get :view
      end

      member do
        post :edit
      end

    end       #----> Fin resources :solicitud_recaudo do

    resources :consulta_plan_inversion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :region_search
        get :municipio_search
        get :ciudad_search
        get :parroquia_search
        get :view
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :consulta_plan_inversion do
    
    resources :sras do

      collection do
        get :view
      end

      member do
      end

    end
    
    resources :solicitud_pre_evaluacion_analisis do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_animales do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_caracterizacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
        get :save_vialidad
        post :save_suelos
        post :save_topografias
        post :save_fuentes_agua
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_colocacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_condicion_acuicultura do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
        get :save_vialidad
        post :save_suelos
        post :save_topografias
        get :save_sistema_cultivo_actual
        get :save_especies
        get :save_especies_solicitadas
        get :save_fuentes_agua
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_infraestructura do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_maquinaria do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
        get :clase_search
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_servicios do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
      end

      member do
        get :edit
        post :new
        post :save_edit
        post :delete
      end

    end
    
    resources :solicitud_pre_evaluacion_visita do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :blanco
        get :confirmar
        get :ver_observaciones
        get :cerrar_observaciones
        get :view
        get :printer
        get :save_new_utm
        post :save_vocacion
        get :save_vocacion
      end

      member do
        post :edit
        post :save_edit
        post :delete
        post :delete_utm
      end

    end

    resources :consulta_sras do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :consulta_sras
    
    
    resources :orden_despacho_archivos_generados do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :preparar_transferencia
        get :preparar_cheque
        
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho_archivos_generados do
    
    
    
    resources :orden_despacho do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :oficina_change
        get :estado_change
        get :casa_proveedora_change
        get :sub_rubro_change
        get :rubro_change
        get :sector_change
        get :collapse
        get :expand_otra
        get :expand
        
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho do

    
    resources :orden_despacho_reimpresion_facturas_confirmadas do

      collection do
        get :list
        post :list
        get :list_especial
        post :list_especial
        get :sector_change
        get :rubro_change
        get :sub_rubro_change
        get :imprimir        
      end

      member do
        post :save_edit
        post :delete
        get :view
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
      end
    end       #----> Fin resources :orden_despacho_reimpresion_facturas_confirmadas
    
    
    
    resources :orden_despacho_consulta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :rubro_change
        get :sub_rubro_change
        get :casa_proveedora_change
        get :casa_change
        get :estado_change
        get :collapse
        get :expand
        
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho_consulta do
    
    resources :orden_despacho_detalle do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :rubro_change
        get :sub_rubro_change
        get :casa_proveedora_change
        get :tipo_casa_proveedora_change
        get :sucursal_casa_proveedora_change
        get :estado_change
        get :collapse
        get :expand
        get :view
        get :confirmar
        get :imprimir1
        get :imprimir2
        get :imprimir3
        get :imprimir_parciales1
        get :imprimir_parciales2
        get :imprimir_parciales3
        get :nueva_orden
        get :nueva_confirmar_parciales
        get :multiples_facturas_confirmar_parciales
        get :save_multiples_confirmar_parciales
        get :save_explicacion_cierre        
        get :eliminar_transaccion_multiple_parcial        
        get :reactualizacion_emitidas
        get :save_nueva_orden                        
        get :cancel_multiple_parcial
        get :abrir_nueva_orden
        get :explicacion_cierre
        
      end

      member do
        post :edit        
        post :new
        post :save_edit        
        post :delete
      end

    end       #----> Fin resources :orden_despacho_detalle do
    
    
    resources :orden_despacho_historico do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :reimpresion        
        get :oficina_change
        get :estado_change
        get :casa_proveedora_change
        get :sector_change
        get :collapse
        get :expand        
        get :view
        get :imprimir
        get :imprimir_todo
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho_historico do
    
    
    
    
    
    resources :orden_despacho_insumo do

      collection do
        get :list
        post :list
        get :index_cheque
        post :index_cheque
        get :preparar_transferencia
        post :preparar_transferencia
        get :preparar_cheque
        post :preparar_cheque
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :total_filtro
        get :entidad_financiera_change
        get :casa_proveedora_change
        get :estado_change
        get :oficina_change
        
      end

      member do
        post :edit
        post :new        
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho_insumo do
    
    
    resources :orden_despacho_rechazo_archivo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :reversar
        get :avanzar_solicitud        
        get :avanzar
        post :avanzar
        get :rectificar
        
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :orden_despacho_rechazo_archivo do
    
    resources :solicitud do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :cerrar_observaciones
        get :tipo_cliente_change
        get :sector_change
        get :sector_tasa_change
        get :sector_tasa_change_list
        get :sub_sector_tasa_change
        get :sub_sector_tasa_change_list
        get :rubro_tasa_change
        get :rubro_tasa_change_list
        get :sector_form_change
        get :sub_sector_change
        get :sub_sector_form_change
        get :rubro_list
        get :rubro_form_select
        get :sub_rubro_form_select
        get :sub_rubro_list
        get :auto_complete_for_cliente_nombre
        get :ubicacion
        get :region_change
        get :estado_change
        get :municipio_change
        post :check_new
        get :revocatoria
        get :anulacion
        post :save_revocatoria
        post :save_anulacion
        get :propuesta_social_trabajadores_change
        get :propuesta_social_comunidad_change
        get :propuesta_social_ambiente_change
        get :ver_observaciones
        get :avanzar
        get :programa_change
        get :rechazar
        get :view
      end

      member do
        post :save_edit        
        post :delete
      end
    end       #----> Fin resources :solicitud

    resources :plan_inversion do

      collection do
        post :actualiza_plan
        get :clase_search
        get :confirmar
        get :delete_maquinaria
        get :delete_confirmado
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :estado_change
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :view
        post :save_maquinaria
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :plan_inversion do
    
    resources :pro_forma do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :estado_change
        get :municipio_change
        get :save_new_mobiliaria1

      end

      member do
        post :save_edit
        post :delete
        post :delete_mobiliaria
      end
    end
    
    resources :reestructuracion do

      collection do
        get :list
        post :list
        post :save_new
        post :view
        get :edit
        get :printer
        get :avanzar_reestructuracion
        post :avanzar_reestructuracion
        get :avanzar_reestructuracion_index
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :estado_change
        get :municipio_change
        get :sub_sector_form_change
        
      end

      member do
        post :save_edit
        post :delete
        get :avanzar_reestructuracion
        post :avanzar_reestructuracion
      end
    end       #----> Fin resources :reestructuracion
    
    
    resources :reestructuracion_comite do

      collection do
        get :list
        post :list
        post :save_new
        get :view
        get :edit
        get :print_propuesta
        get :print_contrato
        get :imprimir_documento
        get :generate_html
        post :reestructurar_deuda
        get :generar_prestamo
        get :show_hide_elementos       
        get :cancel_new
        get :cancel_edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :estado_change
        get :municipio_change
        get :sub_sector_form_change
        get :programa_change
        get :entidad_change
        
      end

      member do
        post :save_edit
        post :delete
        get :entidad_change
      end
    end       #----> Fin resources :reestructuracion_comite
    
    
    ##
    resources :gestionar_garantia do

      collection do
        get :list
        post :list
        post :save_new
        post :delete_mobiliaria
        post :save_informe_new
        post :save_informe_edit
        get :save_constitucion_new
        post :delete_semoviente
        post :save_archivo
        post :edit_informe
        post :delete_imagen
        get :cancel_new
        get :cancel_edit
        get :avanzar
        get :estado_change
        get :municipio_change
        get :clase_search
        get :save_new_informe
        get :save_informe_new
        get :edit_informe
        get :view
        get :ubicacion
        get :save_new_mobiliaria1
        get :save_new_mobiliaria2
        get :constituir
        get :estado_list
        get :etiqueta_folio
        get :view_detail
        get :view_detalle
        get :view_detalle_especifico
        get :view_garantia
        get :view_constitucion
        get :save_archivo
        get :save_new_semoviente
        get :save_constitucion_edit
      end

      member do
        post :save_edit
        post :new
        post :delete
        post :delete_mobiliaria
        post :save_new_semoviente
      end
    end       #----> Fin resources :gestionar_garantia
    
    
    resources :unidades_apoyo_avaluo do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :estado_change
        get :municipio_change
        get :save_new_mobiliaria1

      end

      member do
        post :save_edit
        post :delete
        post :delete_mobiliaria
      end
    end #fin unidades_apoyo_avaluo
    
    ##

  end # del namespace solicitudes

  namespace :visitas do
    
    resources :visita_asignar_tramite do

      collection do
        get :actualizar
        get :list
        post :list
        post :save_observaciones
        post :save_reasignar
        get :save
        get :municipio_change
        get :re_asignar_maxiva
        get :reversar
        get :save_revisado
        get :cancel_new
        get :cancel_edit
        post :save_re_asignar_maxivo
        get :view
      end

      member do
        post :edit
        get :new_reversar
        get :asignar
        get :reasignar
        post :save_asignar
        get :rechazar
      end

    end

    resources :visita_inicial do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :imprimir_sector
        get :view
        get :imprimir
      end

      member do
        post :save_edit
        post :delete
      end
    end
    
    resources :encuesta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :imprimir_sector
        get :view
        get :imprimir
        get :save_visita
        get :save_visita_topico
      end

      member do
        post :save_edit
        post :delete
      end
    end

    resources :recomendacion_plan_inversion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :imprimir_sector
        get :view
        get :imprimir


      end

      member do
        post :save_edit
        post :delete
      end
    end #fin recomendacion_plan_inversion

    resources :visita_solicitud do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :imprimir_sector
        get :view
        get :imprimir
        get :index

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_solicitud

    resources :visita_seguimiento do

      collection do
        get :list
        post :list
        post :save_new
        get :new
        get :cancel_new
        get :cancel_edit
        get :imprimir_sector
        get :beneficiario_atendio_tecnico_click
        get :view
        get :imprimir
        get :confirmar
        get :edit
      end

      member do
        post :save_edit
        post :delete
        post :new
        get :index

      end
    end #fin visita_solicitud

    resources :visita_consulta do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_consulta

    resources :visita_descripciones_especificas do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_descripciones_especificas

    resources :visita_decision do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :presenta_siniestro_click
        get :change_decision

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_decision


    resources :visita_seguimiento_cultivo do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :superficie_efectiva_onchange
        get :change_fecha_siembra
        get :view
        get :edit

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_seguimiento_cultivo

    resources :visita_pastizales_potreros do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        post :cancel_view
        get :cancel_view
        get :cancel_edit
        get :superficie_efectiva_onchange
        get :change_fecha_siembra
        get :tipo_pasto_change
        get :potreros_onchange
        get :sistema_riego_onchange
        get :view
        get :edit

      end

      member do
        post :save_edit
        post :delete
        post :cancel_view
        get :cancel_view
        get :view
        post :view
        get :potreros_onchange
        get :sistema_riego_onchange 
      end
    end #fin visita_pastizales_potreros

    resources :visita_sanidad_animal do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :save_new_vacunacion
        get :delete_vacunacion
        get :remove_vacunacion

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_sanidad_animal

    resources :visita_semovientes do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :total_inventario_onchange
        get :total_vacas_onchange
        get :view
        get :edit

      end

      member do
        post :save_edit
        post :delete
        get :total_inventario_onchange
        get :total_vacas_onchange
      end
    end #fin visita_semovientes

    resources :visita_produccion_leche_carne do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit       
        get :view
        get :edit
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin visita_produccion_leche_carne
    
    resources :condiciones_acuicultura do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        post :new
      end

      member do
        post :save_edit
        post :delete
        get :cancel_view
      end
    end #fin condiciones_acuicultura
    
    resources :cultivo_laguna do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit       
        get :view
        get :edit
        post :new
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin cultivo_laguna
    
    resources :calidad_agua_alimento do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit       
        get :view
        get :edit
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin calidad_agua_alimento
   
    namespace :control_visitas_pesca do

      resources :embarcacion do
        collection do
          get :list
          post :list
          post :save_new
          get :cancel_new
          get :cancel_view
          get :cancel_edit
          get :view
          get :edit
          get :replicar
          post :replicar
          get :estado_search
          get :municipio_search
        end

        member do
          post :save_edit
          post :delete
          get :replicar
          post :replicar
          get :index
          get :cancel_view
        end
        #end #fin embarcacion
      end #fin embarcacion

      resources :motores do
        collection do
          get :list
          post :list
          post :save_new
          get :cancel_new
          get :cancel_edit
          get :view
          get :edit
        end

        member do
          post :save_edit
          post :delete
          get :index
        end
      end #fin motores

      resources :arte_pesca do
        collection do
          get :list
          post :list
          post :save_new
          get :cancel_new
          get :cancel_edit
          get :view
          get :edit
          get :tipo_arte_pesca_change
        end

        member do
          post :save_edit
          post :delete
        end
      end #fin arte_pesca

      resources :equipo_seguridad do
        collection do
          get :list
          post :list
          post :save_new
          get :cancel_new
          get :cancel_edit
          get :view
          get :edit
          get :sector_economico_change
        end

        member do
          post :save_edit
          post :delete
        end
      end #fin equipo_seguridad

      resources :faenas_pesca do
        collection do
          get :list
          post :list
          post :save_new
          get :cancel_new
          get :cancel_edit
          get :view
          get :edit
        end

        member do
          post :save_edit
          post :delete
        end
      end #fin faenas_pesca

    end

  end #fin namespace visitas

  namespace :prestamos do

    resources :simulador do

      collection do

        get :calcular
        post :calcular
        get :imprimir
      end

      member do

        post :calcular
        post :imprimir
      end

    end     # Fin de resources :simulador do

    resources :arrime do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :check
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin arrime

    resources :bandeja_arrime do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :confirmar
        get :sector_change
        get :sector_form_change
        get :sub_sector_change
        get :sub_sector_form_change
        get :rubro_form_change
        get :sub_rubro_change

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin bandeja_arrime
    
    resources :bandeja_otro_arrime do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :confirmar
        get :sector_change
        get :sector_form_change
        get :sub_sector_change
        get :sub_sector_form_change
        get :rubro_form_change
        get :sub_rubro_change

      end

      member do
        post :save_edit
        post :delete
      end
    end #fin bandeja_otro_arrime
    
    resources :pago_arrime do
      collection do
        get :list
        post :list
        get :edit
        get :rubro_change
        get :sub_rubro_change
        post :instruccion_pago

      end

      member do
      end
    end #fin pago_arrime
    
    resources :boleta_arrime do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :silo_change
        get :precio_gaceta_change
        get :imprimir
        get :confirmar
        get :precio_gaceta_change
        get :precio_gaceta_script
        get :save_new_arrime_conjunto
        get :delete_arrime_conjunto
        get :precio_gaceta_script
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin boleta_arrime
    
    resources :cierre_financiero do

      collection do
        get :list
        post :list
        get :xls_cartera
        get :xls_desembolsos
        get :xls_cobranza
        get :xls_sector_estatus
        get :xls_region_estatus
        get :xls_cartera_analista
        get :xls_cartera_codigo_cliente
      end

      member do
        get :list
        get :xls_cartera
        get :xls_desembolsos
        get :xls_cobranza
        get :xls_sector_estatus
        get :xls_region_estatus
        get :xls_cartera_analista
        get :xls_cartera_codigo_cliente
      end
    end
    
    resources :desvio_silo do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :silo_origen_change
        get :silo_destino_change
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin desvio_silo
    
    resources :envio_cobranza do

      collection do

        get :preparar_cobranzas
        get :list
        get :entidad_financiera_change
        post :list
        get :list_view
        post :list_view
      end

    end     # =====> Fin envio_cobrnza

    resources :otro_arrime do
      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :edit
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        get :silo_change 
        get :imprimir
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin otro_arrime
    
    resources :desembolso do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :entidad_financiera_change
        get :oficina_form_change
        get :sector_change
        get :total_filtro
        get :liquidar_cheque
        get :preparar_trasnferencia
        post :preparar_trasnferencia
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :desembolso do



    resources :desembolso_cheque do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :entidad_financiera_change
        get :sector_change
        get :estado_change
        get :total_filtro
        get :preparar_cheque
        post :preparar_cheque
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :desembolso_cheque do


    resources :consulta_prestamo do

      collection do

        post :list
        get :list
      end

      member do
        get :view
        get :imprimir
        get :tasa_historico_list_view
        get :tasa_historico_list
      end

    end     # Fin de resources :consulta_prestamo do

    resources :consulta_prestamo_financiamiento do

      collection do

      end

      member do
        get :view
      end

    end     # Fin de resources :consulta_prestamo_financiamiento do

    resources :consulta_prestamo_plan_pago do

      collection do

        get :plan_pago_change
        get :imprimir
        post :plan_pago_change
      end

      member do

        get :imprimir
      end

    end     # Fin de resources :consulta_prestamo_plan_pago do

    resources :consulta_prestamo_factura do

      collection do

        get :list
        get :index
      end

      member do
        get :view
        get :view_only
        get :list
        get :index
        get :imprimir
      end

    end     # Fin de resources :consulta_prestamo_factura do

    resources :consulta_prestamo_situacion do

      collection do
        get :generar
      end
      
      member do
        get :generar
      end

    end     # Fin de resources :consulta_prestamo_situacion do

    resources :consulta_prestamo_cobranzas do


      member do
        get :view
      end

    end     # Fin de resources :consulta_prestamo_cobranzas do

    resources :consulta_prestamo_desempeno do

      member do
        get :view
      end

    end     # Fin de resources :consulta_prestamo_desempeno do

    resources :consulta_cuenta_proyectado do

      collection do

      end

      member do

      end

    end     # fin de namespace :consulta_cuenta_proyectado do

    resources :control_cobranza do

      collection do
        get :generar_aplicada
        get :imprimir
        get :entidad_financiera_change
        get :list
        post :list
        post :aplicar
        post :confirmar

      end

    end

    resources :pago do
    
      collection do
      
        get :resumen        
        get :list
        post :list
        get :pagar
        post :ejecutar_pago
        get :exigible_change
        get :modalidad_change
        get :agregar_cheque
        get :entidad_change
        post :eliminar_cheque
      end
      
      member do
      
        get :pagar
        post :ejecutar_pago
        get :list
        post :eliminar_cheque
        get :agregar_cheque
      end
    end

    resources :prestamo_cambio_estatus do
    
      collection do

        get :edit
        get :list
        post :list
        post :save_edit
      end
      
      member do
      
        post :save_edit
      end
    end
    
    resources :cobranza_aplicada do

      collection do
        get :reporte
        post :reporte
      end

      member do
        get :reporte
        post :reporte
      end
    end

    resources :reporte_analisis_ejecucion do
      collection do
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        post :procesar_reporte
      end

      member do
      end
    end
    
    resources :rechazo_domiciliacion do

      collection do
        get :reporte
        post :reporte
      end

      member do
        get :reporte
        post :reporte
      end
    end
    
    resources :reporte_cobranza do

      collection do
        get :reporte
        post :reporte
      end

      member do
        get :reporte
        post :reporte
      end
    end

    resources :reporte_otorgados_por_trimestre do
      collection do
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        post :procesar_reporte
      end

      member do
      end
    end

    resources :reporte_pidan do
      collection do
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        post :procesar_reporte
      end

      member do
      end
    end
    
    resources :reporte_proyeccion_recuperacion do
      collection do
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        post :procesar_reporte
      end

      member do
      end
    end

    resources :reporte_rendiciones_por_trimestre do
      collection do
        get :sector_change
        get :sub_sector_change
        get :rubro_change
        get :sub_rubro_change
        post :procesar_reporte
      end

      member do
      end
    end
    
  end       # fin de namespace :prestamos do


  namespace :finanzas do
    
    resources :consulta_abono_arrime_confirmacion_transferencia do

      collection do
        post :list
      end

    end
    
    resources :rechazo_excedente_abono_arrime do

      collection do
        get :avanzar
        post :list
      end

    end
    
    resources :rechazo_liquidacion_transferencia do

      collection do
        get :avanzar
        post :list
      end

    end

    resources :generacion_tabla do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :generar_tabla
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :generacion_tabla do

    resources :fecha_liquidacion do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        post :avanzar
        get :avanzar
        get :avanzar_solicitud
        get :reversar
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :fecha_liquidacion do



    resources :actualizacion_fideicomiso do

      collection do
        get :list
        post :list
        post :save_new
        get :tipo_m_change
        get :cancel_new
        get :cancel_edit
        get :entidad_form_change
        get :edit
        get :delete        
        get :nro_fideicomiso_change
        get :entidad_form_change        
      end

      member do        
        post :new
        post :save_edit        
      end

    end       #----> Fin resources :actualizacion_fideicomiso do


    resources :consulta_disponibilidad_fideicomiso do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view        
        get :entidad_form_change
        get :entidad_change
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :consulta_disponibilidad_fideicomiso do

    resources :abono_arrime_cheque do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :total_filtro
        get :estado_change
        get :sector_change
        get :entidad_financiera_change
        get :preparar_cheque
        post :preparar_cheque

      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :abono_arrime_cheque do

    resources :abono_arrime_confirmacion_transferencia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :reversar
        get :avanzar_solicitud
        get :consulta_transferencias
        post :consulta_transferencias
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :abono_arrime_confirmacion_transferencia do

    resources :abono_arrime_registro_cheque do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :generar_tabla
        get :sub_sector_search
        get :sector_search
        get :rubro_search
        get :sub_rubro_search
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :abono_arrime_registro_cheque do

    resources :abono_arrime_transferencia do

      collection do
        get :list
        post :list
        post :save_new
        get :cancel_new
        get :cancel_edit
        get :view
        get :total_filtro
        get :sector_change
        get :oficina_form_change
        get :entidad_financiera_change
        get :preparar_trasnferencia
        post :preparar_trasnferencia
      end

      member do
        post :edit
        post :new
        post :save_edit
        post :delete
      end

    end       #----> Fin resources :abono_arrime_transferencia do
    
    resources :excedentes_arrime do
      collection do
        get :list
        post :list
        get :view
        get :pagar_excedente
      end

      member do
        post :save_edit
        post :delete
      end
    end #fin excedente_arrime

  end   #namespace finanzas



  resources :consulta_solicitud do

    get 'revisar', :on => :collection
    member do
      post 'avanzar'
      get 'consulta'
    end
  end
  


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
