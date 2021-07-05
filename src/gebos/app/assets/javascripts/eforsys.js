function image_load() {
	Element.show('loading');
}

function image_unload() {
	Element.hide('loading');
}

function textCounter(field, maxlimit) {
	if (field.value.length > maxlimit) // if too long...trim it!
		field.value = field.value.substring(0, maxlimit);
}

function inputChange() {
	if ($('button_close')) {
		Element.hide('button_close');
	}
	if ($('message')) {
		Element.hide('message');
	}
	if ($('buttons_edit')) {
		Element.show('buttons_edit');
	}
}
function formatNumerLuis(num) {

    num = num.toString().replace(/\$|\,/g,'.');

    if(isNaN(num))
        num = "0";

    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();

    if(cents<10)
        cents = "0" + cents;

    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+'.'+
        num.substring(num.length-(4*i+3));
        
    numero = (((sign)?'':'-') + num + ',' + cents);
    return numero;
    
}

function formatCurrency(num, name) {

    num = num.toString().replace(/\$|\,/g,'.');

    if(isNaN(num))
        num = "0";

    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();

    if(cents<10)
        cents = "0" + cents;

    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+'.'+
        num.substring(num.length-(4*i+3));
        
    numero = (((sign)?'':'-') + num + ',' + cents);
    $(name + '_display').innerHTML = numero;
    
}

function formatCurrency1(num, name) {

    num = num.toString().replace(/\$|\,/g,'.');

    if(isNaN(num))
        num = "0";

    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*1000+0.50000000001);
    cents = num%1000;
    num = Math.floor(num/1000).toString();

    if(cents<100)
        cents = "0" + cents;

    if(cents<10) 
        cents = "00" + cents;

    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+'.'+
        num.substring(num.length-(4*i+3));
        
    numero = (((sign)?'':'-') + num + ',' + cents);
    $(name + '_display').innerHTML = numero;
    
}
function cambio_bsf(fec,monto,campo){
    var fecha = fec;
    var monto_bsf = monto;
    monto_bsf = monto_bsf.replace(",",".");
           
    if (fecha.length == 10 && fecha != ''){
        anio = fecha.substring(fecha.length - 4,fecha.length);
        anio = anio /1;

        if (anio >= 2008){
            monto_bsf = monto_bsf;
        }else{
            monto_bsf = monto_bsf/1000;

        }
    }else{
        monto_bsf = monto_bsf;
    }

    document.getElementById(campo).value = monto_bsf;

    //caso: solicitud de desembolsos ya que los items no estan creados correctamente
    if (campo.substr(0,16) == "desembolso_pago_"){
        campo = "desembolso_pago_monto";
    }
    //-------------------------------------
  
    document.getElementById(campo+'_moneda').innerHTML = "Bs.";
    
    campo_aux = campo;
    if (campo.substring(campo.length-2, campo.length) == "_f"){
        
        campo = campo.substring(0, campo.length-2);
    }    
    
    formatCurrency(monto_bsf, campo);
    aux = document.getElementById(campo+'_display').innerHTML;
    aux = aux.replace(".","");aux = aux.replace(".","");aux = aux.replace(".","");aux = aux.replace(".","");aux = aux.replace(".","");aux = aux.replace(".","");
    aux = aux.replace(",",".");
    document.getElementById(campo_aux).value = aux    

}


function cambio_etiqueta(fec,campo){

        var label = "Bs.F";
        var fecha = fec;
        var longitud = fecha.length;
    
        if (longitud == 10){
            anio = fecha.substring(fecha.length - 4,fecha.length);
            if (anio >= 2008){
                etiqueta = "Bs.F.";
            }else{
                etiqueta = "Bs."
            }
        document.getElementById(campo+'_moneda').innerHTML = etiqueta;
        }

}

function etiquetas_form(fec,campos){
    var fecha = fec;
    var camposSplit = campos.split("/");
    var aux = camposSplit.length -1;
    
    etiqueta = "Bs.";
    
    if (fecha.length = 10){
        anio = fecha.substring(fecha.length - 4,fecha.length);
        if (anio >= 2008){
            etiqueta = "Bs.";
            alert("las cantidades en moneda que introduzca en este formulario deben estar expresadas en Bolívares Fuertes !!!");
        }else{
            etiqueta = "Bs."
            alert("Usted está colocando una fecha anterior al 2008. Los montos en Bolívares convencionales que usted introduzca, serán convertidos automaticamente a Bolívares Fuertes !!!")
        }
    
    }
    while(aux >= 0){
        campo = camposSplit[aux];
        document.getElementById(campo+'_moneda').innerHTML = etiqueta;
        aux = aux-1;
    }
}
function etiquetas2_form(fec,campos){
    var fecha = fec;
    var camposSplit = campos.split("/");
    var aux = camposSplit.length -1;
    
    etiqueta = "Bs.";
    
    if (fecha.length = 10){
        anio = fecha.substring(fecha.length - 4,fecha.length);
        if (anio >= 2008){
            etiqueta = "Bs.";
            alert("Los montos obtenidos de la simulación se encuentran expresados en Bolívares Fuertes !!!");
        }else{
            etiqueta = "Bs."
            alert("Usted está colocando una fecha anterior al 2008. Los montos obtenidos de la simulación serán expresados en Bolívares convencionales !!!")
        }
    
    }
    document.getElementById(campos+'_moneda').innerHTML = etiqueta;

}
function format_number(numero){
	numero = Math.round((numero)*100)/100;
	numero = numero.toString()
	var ja = numero.split(".")
	var num = ja[0]
	
	if (ja[1]==null){ja[1]='00'}
	num = num/1
	
	if (num >= 1000 || num <= -1000){
		var number_string = Math.abs(num).toString()
		var insert_position
		
		switch (number_string.length % 3){
			case 1:
				insert_position = 1
				break
			case 2:
				insert_position = 2
				break
			case 0:
				insert_position = 3
				break
		}
		while (insert_position < number_string.length){
			number_string = number_string.left(insert_position)+"."+number_string.substring(insert_position)
			insert_position += 4
		}
		
		if (num < 0){
			return "-"+number_string+","+ja[1]
		}
		else{
			return number_string+","+ja[1]
		}
	}
	else{
		return num.toString()	
	}
}
