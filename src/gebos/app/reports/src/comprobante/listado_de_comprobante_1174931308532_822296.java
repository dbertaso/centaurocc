/*
 * Generated by JasperReports - 3/26/07 1:48 PM
 */
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.fill.*;

import java.util.*;
import java.math.*;
import java.text.*;
import java.io.*;
import java.net.*;

import java.util.*;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.*;


/**
 *
 */
public class listado_de_comprobante_1174931308532_822296 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_REPORT_DATE_FORMAT_FACTORY = null;
    private JRFillParameter parameter_REPORT_CLASS_LOADER = null;
    private JRFillParameter parameter_p_id_prestamo = null;
    private JRFillParameter parameter_REPORT_TIME_ZONE = null;
    private JRFillParameter parameter_REPORT_DATA_SOURCE = null;
    private JRFillParameter parameter_REPORT_LOCALE = null;
    private JRFillParameter parameter_REPORT_URL_HANDLER_FACTORY = null;
    private JRFillParameter parameter_REPORT_PARAMETERS_MAP = null;
    private JRFillParameter parameter_REPORT_CONNECTION = null;
    private JRFillParameter parameter_IS_IGNORE_PAGINATION = null;
    private JRFillParameter parameter_SUBREPORT_DIR = null;
    private JRFillParameter parameter_REPORT_VIRTUALIZER = null;
    private JRFillParameter parameter_p_fecha_hasta = null;
    private JRFillParameter parameter_p_fecha_desde = null;
    private JRFillParameter parameter_REPORT_SCRIPTLET = null;
    private JRFillParameter parameter_REPORT_MAX_COUNT = null;
    private JRFillField field_monto_mora = null;
    private JRFillField field_id_solicitud = null;
    private JRFillField field_id_prestamo = null;
    private JRFillField field_fecha_inicio = null;
    private JRFillField field_total_exigible = null;
    private JRFillField field_dia_facturacion = null;
    private JRFillField field_base_calculo_intereses = null;
    private JRFillField field_meses_fijos_sin_cambio_tasa = null;
    private JRFillField field_id_partida = null;
    private JRFillField field_id_tipo_credito = null;
    private JRFillField field_interes_desembolso_vencido = null;
    private JRFillField field_interes_diferido_vencido = null;
    private JRFillField field_nombre_empresa = null;
    private JRFillField field_tasa_vigente = null;
    private JRFillField field_numero_prestamo = null;
    private JRFillField field_cantidad_cuotas_vencidas = null;
    private JRFillField field_id_empresa = null;
    private JRFillField field_numero_solicitud = null;
    private JRFillField field_dia_cuota = null;
    private JRFillField field_dias_mora = null;
    private JRFillField field_prestamo_monto_solicitado = null;
    private JRFillField field_rif = null;
    private JRFillField field_tasa_fija = null;
    private JRFillField field_numero = null;
    private JRFillField field_monto_vencido = null;
    private JRFillField field_nombre_tipo_credito = null;
    private JRFillField field_valor_cuota = null;
    private JRFillField field_nombre_partida = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;
    private JRFillVariable variable_prestamo_COUNT = null;


    /**
     *
     */
    public void customizedInit(
        Map pm,
        Map fm,
        Map vm
        )
    {
        initParams(pm);
        initFields(fm);
        initVars(vm);
    }


    /**
     *
     */
    private void initParams(Map pm)
    {
        parameter_REPORT_RESOURCE_BUNDLE = (JRFillParameter)pm.get("REPORT_RESOURCE_BUNDLE");
        parameter_REPORT_DATE_FORMAT_FACTORY = (JRFillParameter)pm.get("REPORT_DATE_FORMAT_FACTORY");
        parameter_REPORT_CLASS_LOADER = (JRFillParameter)pm.get("REPORT_CLASS_LOADER");
        parameter_p_id_prestamo = (JRFillParameter)pm.get("p_id_prestamo");
        parameter_REPORT_TIME_ZONE = (JRFillParameter)pm.get("REPORT_TIME_ZONE");
        parameter_REPORT_DATA_SOURCE = (JRFillParameter)pm.get("REPORT_DATA_SOURCE");
        parameter_REPORT_LOCALE = (JRFillParameter)pm.get("REPORT_LOCALE");
        parameter_REPORT_URL_HANDLER_FACTORY = (JRFillParameter)pm.get("REPORT_URL_HANDLER_FACTORY");
        parameter_REPORT_PARAMETERS_MAP = (JRFillParameter)pm.get("REPORT_PARAMETERS_MAP");
        parameter_REPORT_CONNECTION = (JRFillParameter)pm.get("REPORT_CONNECTION");
        parameter_IS_IGNORE_PAGINATION = (JRFillParameter)pm.get("IS_IGNORE_PAGINATION");
        parameter_SUBREPORT_DIR = (JRFillParameter)pm.get("SUBREPORT_DIR");
        parameter_REPORT_VIRTUALIZER = (JRFillParameter)pm.get("REPORT_VIRTUALIZER");
        parameter_p_fecha_hasta = (JRFillParameter)pm.get("p_fecha_hasta");
        parameter_p_fecha_desde = (JRFillParameter)pm.get("p_fecha_desde");
        parameter_REPORT_SCRIPTLET = (JRFillParameter)pm.get("REPORT_SCRIPTLET");
        parameter_REPORT_MAX_COUNT = (JRFillParameter)pm.get("REPORT_MAX_COUNT");
    }


    /**
     *
     */
    private void initFields(Map fm)
    {
        field_monto_mora = (JRFillField)fm.get("monto_mora");
        field_id_solicitud = (JRFillField)fm.get("id_solicitud");
        field_id_prestamo = (JRFillField)fm.get("id_prestamo");
        field_fecha_inicio = (JRFillField)fm.get("fecha_inicio");
        field_total_exigible = (JRFillField)fm.get("total_exigible");
        field_dia_facturacion = (JRFillField)fm.get("dia_facturacion");
        field_base_calculo_intereses = (JRFillField)fm.get("base_calculo_intereses");
        field_meses_fijos_sin_cambio_tasa = (JRFillField)fm.get("meses_fijos_sin_cambio_tasa");
        field_id_partida = (JRFillField)fm.get("id_partida");
        field_id_tipo_credito = (JRFillField)fm.get("id_tipo_credito");
        field_interes_desembolso_vencido = (JRFillField)fm.get("interes_desembolso_vencido");
        field_interes_diferido_vencido = (JRFillField)fm.get("interes_diferido_vencido");
        field_nombre_empresa = (JRFillField)fm.get("nombre_empresa");
        field_tasa_vigente = (JRFillField)fm.get("tasa_vigente");
        field_numero_prestamo = (JRFillField)fm.get("numero_prestamo");
        field_cantidad_cuotas_vencidas = (JRFillField)fm.get("cantidad_cuotas_vencidas");
        field_id_empresa = (JRFillField)fm.get("id_empresa");
        field_numero_solicitud = (JRFillField)fm.get("numero_solicitud");
        field_dia_cuota = (JRFillField)fm.get("dia_cuota");
        field_dias_mora = (JRFillField)fm.get("dias_mora");
        field_prestamo_monto_solicitado = (JRFillField)fm.get("prestamo_monto_solicitado");
        field_rif = (JRFillField)fm.get("rif");
        field_tasa_fija = (JRFillField)fm.get("tasa_fija");
        field_numero = (JRFillField)fm.get("numero");
        field_monto_vencido = (JRFillField)fm.get("monto_vencido");
        field_nombre_tipo_credito = (JRFillField)fm.get("nombre_tipo_credito");
        field_valor_cuota = (JRFillField)fm.get("valor_cuota");
        field_nombre_partida = (JRFillField)fm.get("nombre_partida");
    }


    /**
     *
     */
    private void initVars(Map vm)
    {
        variable_PAGE_NUMBER = (JRFillVariable)vm.get("PAGE_NUMBER");
        variable_COLUMN_NUMBER = (JRFillVariable)vm.get("COLUMN_NUMBER");
        variable_REPORT_COUNT = (JRFillVariable)vm.get("REPORT_COUNT");
        variable_PAGE_COUNT = (JRFillVariable)vm.get("PAGE_COUNT");
        variable_COLUMN_COUNT = (JRFillVariable)vm.get("COLUMN_COUNT");
        variable_prestamo_COUNT = (JRFillVariable)vm.get("prestamo_COUNT");
    }


    /**
     *
     */
    public Object evaluate(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("./");
                break;
            }
            case 1 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()).toString() + ((java.lang.Integer)field_id_prestamo.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 19 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_cantidad_cuotas_vencidas.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_vencido.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_valor_cuota.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_mora.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_desembolso_vencido.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_diferido_vencido.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_total_exigible.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateOld(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("./");
                break;
            }
            case 1 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getOldValue()).toString() + ((java.lang.Integer)field_id_prestamo.getOldValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 19 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_cantidad_cuotas_vencidas.getOldValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_vencido.getOldValue()));
                break;
            }
            case 24 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_valor_cuota.getOldValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_mora.getOldValue()));
                break;
            }
            case 26 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_desembolso_vencido.getOldValue()));
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_diferido_vencido.getOldValue()));
                break;
            }
            case 28 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_total_exigible.getOldValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


    /**
     *
     */
    public Object evaluateEstimated(int id) throws Throwable
    {
        Object value = null;

        switch (id)
        {
            case 0 : 
            {
                value = (java.lang.String)("./");
                break;
            }
            case 1 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 2 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 3 : 
            {
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 6 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 7 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 14 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_solicitud.getValue()).toString() + ((java.lang.Integer)field_id_prestamo.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 18 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 19 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_cantidad_cuotas_vencidas.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_vencido.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_valor_cuota.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_monto_mora.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_desembolso_vencido.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_interes_diferido_vencido.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_total_exigible.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
