# encoding: utf-8

#
# 
# clase: ViewAperturaComite
# descripción: Migración a Rails 3
#

class ViewAperturaComite < ActiveRecord::Base

  self.table_name = 'view_apertura_comite'



  attr_accessible   :id,
                    :numero,
                    :fecha_apertura,
                    :vigente,
                    :cantidad,
                    :monto,
                    :orden

  
  def self.fecha_escrita(fecha)
    fecha = fecha.strftime('%d/%m/%Y')
    if fecha[0,2].to_i == 1
      dia = 'el primer día '
    else
      dia = monto_escrito(fecha[0,2].to_i, false)
      dia = "a los #{dia} días "
    end
    mes = mes_escrito(fecha[3,2].to_i)
    anno = fecha[6,4]
    return dia << "del mes de #{mes}" << " de #{anno}"
  end

  def self.mes_escrito(mes)
    if mes == 1
      return 'enero'
    elsif mes == 2
      return 'febrero'
    elsif mes == 3
      return 'marzo'
    elsif mes == 4
      return 'abril'
    elsif mes == 5
      return 'mayo'
    elsif mes == 6
      return 'junio'
    elsif mes == 7
      return 'julio'
    elsif mes == 8
      return 'agosto'
    elsif mes == 9
      return 'septiembre'
    elsif mes == 10
      return 'octubre'
    elsif mes == 11
      return 'noviembre'
    elsif mes == 12
      return 'diciembre'
    end
  end

  def self.monto_escrito(monto, opcion)
      texto = ""
      inicial = monto
      cenmillon = (inicial / 100000000).truncate
      decmillon = ((inicial - (cenmillon * 100000000))/10000000).truncate
      unimillon = ((inicial-(cenmillon * 100000000) - (decmillon * 10000000)) / 1000000).truncate

      if cenmillon == 1
        if decmillon == 0
          if unimillon == 0
            texto = texto + 'cien '
          else
            texto = texto + 'ciento '
          end
        else
          texto = texto + 'ciento '
        end
      elsif cenmillon == 2
        texto = texto + 'doscientos '
      elsif cenmillon == 3
        texto = texto + 'trescientos '
      elsif cenmillon == 4
        texto = texto + 'cuatrocientos '
      elsif cenmillon == 5
        texto = texto + 'quinientos '
      elsif cenmillon == 6
        texto = texto + 'seiscientos '
      elsif cenmillon == 7
        texto = texto + 'setescientos '
      elsif cenmillon == 8
        texto = texto + 'ochocientos '
      elsif cenmillon == 9
        texto = texto + 'novescientos '
      else
        texto = texto
      end

      if decmillon == 1
        if unimillon == 0
          texto = texto + 'diez millon'
        elsif unimillon == 1
          texto = texto + 'once millon'
        elsif unimillon == 2
          texto = texto + 'doce millon'
        elsif unimillon == 3
          texto = texto + 'trece millon'
        elsif unimillon == 4
          texto = texto + 'catorce millon'
        elsif unimillon == 5
          texto = texto + 'quince millon'
        elsif unimillon == 6
          texto = texto + 'dieciseis millon'
        elsif unimillon == 7
          texto = texto + 'diecisiete millon'
        elsif unimillon == 8
          texto = texto + 'dieciocho millon'
        elsif unimillon == 9
          texto = texto + 'diecinueve millon'
        else
          texto = texto
        end
      end

      if decmillon == 2
        if unimillon == 0
          texto = texto + 'veinte '
        else
          texto = texto + 'veinti'
        end
      elsif decmillon == 3
        texto = texto + 'treinta '
      elsif decmillon == 4
        texto = texto + 'cuarenta '
      elsif decmillon == 5
        texto = texto + 'cincuenta '
      elsif decmillon == 6
        texto = texto + 'sesenta '
      elsif decmillon == 7
        texto = texto + 'setenta '
      elsif decmillon == 8
        texto = texto + 'ochenta '
      elsif decmillon == 9
        texto = texto + 'noventa '
      end

      if decmillon > 2
        if unimillon > 0
          texto = texto + 'y '
        end
      end

      if decmillon != 1
        if unimillon == 0
          if cenmillon ==0 && decmillon == 0
            texto = texto
          else
            texto = texto + 'millon'
          end
        elsif unimillon == 1
          texto = texto + 'un millon'
        elsif unimillon == 2
          texto = texto + 'dos millon'
        elsif unimillon == 3
          texto = texto + 'tres millon'
        elsif unimillon == 4
          texto = texto + 'cuatro millon'
        elsif unimillon == 5
          texto = texto + 'cinco millon'
        elsif unimillon == 6
          texto = texto + 'seis millon'
        elsif unimillon == 7
          texto = texto + 'siete millon'
        elsif unimillon == 8
          texto = texto + 'ocho millon'
        elsif unimillon == 9
          texto = texto + 'nueve millon'
        end
      end

      if cenmillon > 0 || decmillon > 0
        texto = texto + 'es '
      elsif decmillon == 0 && unimillon ==1
        texto = texto + ' '
      elsif decmillon == 0 && unimillon > 1
        texto = texto + 'es '
      end

      quedan = inicial -((cenmillon * 100000000) + (decmillon * 10000000)+(unimillon * 1000000))
      cenmillar = (quedan / 100000).truncate
      decmillar = ((quedan -(cenmillar * 100000)) / 10000).truncate
      unimillar = ((quedan -(cenmillar * 100000) - (decmillar * 10000)) / 1000).truncate


      if cenmillar == 1
        if decmillar > 0
          texto = texto + 'ciento '
        else
          texto = texto + 'cien '
        end
      elsif cenmillar == 2
        texto = texto + 'doscientos '
      elsif cenmillar == 3
        texto = texto + 'trescientos '
      elsif cenmillar == 4
        texto = texto + 'cuatrocientos '
      elsif cenmillar == 5
        texto = texto + 'quinientos '
      elsif cenmillar == 6
        texto = texto + 'seiscientos '
      elsif cenmillar == 7
        texto = texto + 'setecientos '
      elsif cenmillar == 8
        texto = texto + 'ochocientos '
      elsif cenmillar == 9
        texto = texto + 'novecientos '
      end

      if decmillar == 1
        if unimillar == 0
          texto = texto + 'diez mil '
        elsif unimillar == 1
          texto = texto + 'once mil '
        elsif unimillar == 2
          texto = texto + 'doce mil '
        elsif unimillar == 3
          texto = texto + 'trece mil '
        elsif unimillar == 4
          texto = texto + 'catorce mil '
        elsif unimillar == 5
          texto = texto + 'quince mil '
        elsif unimillar == 6
          texto = texto + 'dieciseis mil '
        elsif unimillar == 7
          texto = texto + 'diecisiete mil '
        elsif unimillar == 8
          texto = texto + 'dieciocho mil '
        elsif unimillar == 9
          texto = texto + 'diecinueve mil '
        else
          texto = texto
        end
      elsif decmillar == 2
        if unimillar == 0
          texto = texto + 'veinte mil '
        else
          texto = texto + 'veinti'
        end
      elsif decmillar == 3
        texto = texto + 'treinta '
      elsif decmillar == 4
        texto = texto + 'cuarenta '
      elsif decmillar == 5
        texto = texto + 'cincuenta '
      elsif decmillar == 6
        texto = texto + 'sesenta '
      elsif decmillar == 7
        texto = texto + 'setenta '
      elsif decmillar == 8
        texto = texto + 'ochenta '
      elsif decmillar == 9
        texto = texto + 'noventa '
      end

      if decmillar > 2
        if unimillar > 0
          texto = texto + 'y '
        end
      end
      if decmillar != 1
        if unimillar == 1
          texto = texto + 'un mil '
        elsif unimillar == 2
          texto = texto + 'dos mil '
        elsif unimillar == 3
          texto = texto + 'tres mil '
        elsif unimillar == 4
          texto = texto + 'cuatro mil '
        elsif unimillar == 5
          texto = texto + 'cinco mil '
        elsif unimillar == 6
          texto = texto + 'seis mil '
        elsif unimillar == 7
          texto = texto + 'siete mil '
        elsif unimillar == 8
          texto = texto + 'ocho mil '
        elsif unimillar == 9
          texto = texto + 'nueve mil '
        elsif unimillar == 0 && (decmillar != 0 || cenmillar != 0)
          texto = texto + 'mil '
        elsif unimillar == 0 && decmillar == 0 && cenmillar == 0
          texto = texto + ''
        end

      end
      quedan = inicial - ((cenmillon * 100000000) + (decmillon * 10000000) + (unimillon * 1000000) + (cenmillar * 100000) + (decmillar * 10000) + (unimillar * 1000))
      centenas = (quedan / 100).truncate
      decenas = ((quedan -(centenas * 100)) / 10).truncate
      unidades = ((quedan -(centenas * 100) -(decenas * 10))).truncate

      if centenas == 1
        texto = texto + 'ciento '
      elsif centenas == 2
        texto = texto + 'doscientos '
      elsif centenas == 3
        texto = texto + 'trescientos '
      elsif centenas == 4
        texto = texto + 'cuatrocientos '
      elsif centenas == 5
        texto = texto + 'quinientos '
      elsif centenas == 6
        texto = texto + 'seiscientos '
      elsif centenas == 7
        texto = texto + 'setecientos '
      elsif centenas == 8
        texto = texto + 'ochocientos '
      elsif centenas == 9
        texto = texto + 'novecientos '
      end
      if decenas == 1
        if unidades == 0
          texto = texto + 'diez '
        elsif unidades == 1
          texto = texto + 'once '
        elsif unidades == 2
          texto = texto + 'doce'
        elsif unidades == 3
          texto = texto + 'trece '
        elsif unidades == 4
          texto = texto + 'catorce '
        elsif unidades == 5
          texto = texto + 'quince '
        elsif unidades == 6
          texto = texto + 'dieciseis '
        elsif unidades == 7
          texto = texto + 'diecisiete'
        elsif unidades == 8
          texto = texto + 'dieciocho'
        elsif unidades == 9
          texto = texto + 'diecinueve '
        else
          texto = texto
        end
      elsif decenas == 2
        if unidades == 0
          texto = texto + 'veinte '
        else
          texto = texto + 'veinti'
        end
      elsif decenas == 3
        texto = texto + 'treinta '
      elsif decenas == 4
        texto = texto + 'cuarenta '
      elsif decenas == 5
        texto = texto + 'cincuenta '
      elsif decenas == 6
        texto = texto + 'sesenta '
      elsif decenas == 7
        texto = texto + 'setenta '
      elsif decenas == 8
        texto = texto + 'ochenta '
      elsif decenas == 9
        texto = texto + 'noventa '
      end

      if decenas > 2
        if unidades > 0
          texto = texto + 'y '
        end
      end
      if decenas != 1
        if unidades == 1
          if opcion == true
            texto = texto + 'un '
          elsif opcion == false
            texto = texto + 'uno'
          end
        elsif unidades == 2
          texto = texto + 'dos '
        elsif unidades == 3
          texto = texto + 'tres '
        elsif unidades == 4
          texto = texto + 'cuatro '
        elsif unidades == 5
          texto = texto + 'cinco '
        elsif unidades == 6
          texto = texto + 'seis '
        elsif unidades == 7
          texto = texto + 'siete '
        elsif unidades == 8
          texto = texto + 'ocho '
        elsif unidades == 9
          texto = texto + 'nueve '
        elsif unidades == 0 && decenas == 0 && centenas == 0
          texto = texto
        end
      end
  #    unless opcion == false
  #      if cenmillar == 0 && decmillar == 0 && unimillar == 0 && unidades == 0 && decenas == 0 && centenas == 0
  #        texto = texto + 'de '
  #      end
  #      texto = texto + 'bolívares'
  #    end
      centimos = inicial - inicial.truncate
      centimos = centimos * 100
      centimos = centimos.round

      if centimos > 0
        texto = texto + ' con '
        decenas_centimos = (centimos / 10).truncate
        unidades_centimos = ((centimos) -(decenas_centimos * 10)).truncate
        if decenas_centimos == 1
          if unidades_centimos == 0
            texto = texto + 'diez '
          elsif unidades_centimos == 1
            texto = texto + 'once '
          elsif unidades_centimos == 2
            texto = texto + 'doce'
          elsif unidades_centimos == 3
            texto = texto + 'trece '
          elsif unidades_centimos == 4
            texto = texto + 'catorce '
          elsif unidades_centimos == 5
            texto = texto + 'quince '
          elsif unidades_centimos == 6
            texto = texto + 'dieciseis '
          elsif unidades_centimos == 7
            texto = texto + 'diecisiete'
          elsif unidades_centimos == 8
            texto = texto + 'dieciocho'
          elsif unidades_centimos == 9
            texto = texto + 'diecinueve '
          else
            texto = texto
          end
        elsif decenas_centimos == 2
          if unidades_centimos == 0
            texto = texto + 'veinte '
          else
            texto = texto + 'veinti'
          end
        elsif decenas_centimos == 3
          texto = texto + 'treinta '
        elsif decenas_centimos == 4
          texto = texto + 'cuarenta '
        elsif decenas_centimos == 5
          texto = texto + 'cincuenta '
        elsif decenas_centimos == 6
          texto = texto + 'sesenta '
        elsif decenas_centimos == 7
          texto = texto + 'setenta '
        elsif decenas_centimos == 8
          texto = texto + 'ochenta '
        elsif decenas_centimos == 9
          texto = texto + 'noventa '
        end

        if decenas_centimos > 2
          if unidades_centimos > 0
            texto = texto + 'y '
          end
        end
        if decenas_centimos != 1
          if unidades_centimos == 1
              texto = texto + 'un '
          elsif unidades_centimos == 2
            texto = texto + 'dos '
          elsif unidades_centimos == 3
            texto = texto + 'tres '
          elsif unidades_centimos == 4
            texto = texto + 'cuatro '
          elsif unidades_centimos == 5
            texto = texto + 'cinco '
          elsif unidades_centimos == 6
            texto = texto + 'seis '
          elsif unidades_centimos == 7
            texto = texto + 'siete '
          elsif unidades_centimos == 8
            texto = texto + 'ocho '
          elsif unidades_centimos == 9
            texto = texto + 'nueve '
          elsif unidades_centimos == 0 && decenas_centimos == 0
            texto = texto
          end
        end
        texto = texto + 'céntimos'
      else
        texto = texto
      end
      if texto.empty?
        texto = 'cero'
      end
      return texto
    end
  
end

# == Schema Information
#
# Table name: view_apertura_comite
#
#  id             :integer         primary key
#  numero         :string(15)
#  fecha_apertura :date
#  vigente        :boolean
#  cantidad       :integer
#  monto          :float
#  orden          :integer
#

