/*
 * Generated by JasperReports - 6/11/07 9:32 AM
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
public class montos_colocados_intermediarios_1181568735298_447065 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_REPORT_DATE_FORMAT_FACTORY = null;
    private JRFillParameter parameter_REPORT_CLASS_LOADER = null;
    private JRFillParameter parameter_p_fecha_fin = null;
    private JRFillParameter parameter_REPORT_TIME_ZONE = null;
    private JRFillParameter parameter_p_fecha_inicio = null;
    private JRFillParameter parameter_REPORT_DATA_SOURCE = null;
    private JRFillParameter parameter_REPORT_LOCALE = null;
    private JRFillParameter parameter_REPORT_URL_HANDLER_FACTORY = null;
    private JRFillParameter parameter_REPORT_PARAMETERS_MAP = null;
    private JRFillParameter parameter_REPORT_CONNECTION = null;
    private JRFillParameter parameter_IS_IGNORE_PAGINATION = null;
    private JRFillParameter parameter_REPORT_VIRTUALIZER = null;
    private JRFillParameter parameter_REPORT_SCRIPTLET = null;
    private JRFillParameter parameter_REPORT_MAX_COUNT = null;
    private JRFillField field_nombre_empresa = null;
    private JRFillField field_plazo_gracia = null;
    private JRFillField field_numero_prestamo = null;
    private JRFillField field_tasa_intermediario = null;
    private JRFillField field_tasa_foncrei = null;
    private JRFillField field_regimen = null;
    private JRFillField field_nombre_entidad_financiera = null;
    private JRFillField field_id_entidad_financiera = null;
    private JRFillField field_monto_prestamo = null;
    private JRFillField field_fecha_acta_directorio = null;
    private JRFillField field_plazo_amo = null;
    private JRFillField field_saldo_deudor = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;
    private JRFillVariable variable_entidad_financiera_COUNT = null;
    private JRFillVariable variable_v_sum_deuda_by_entidad_financiera = null;
    private JRFillVariable variable_v_sum_deuda_by_report = null;
    private JRFillVariable variable_v_regimen = null;


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
        parameter_p_fecha_fin = (JRFillParameter)pm.get("p_fecha_fin");
        parameter_REPORT_TIME_ZONE = (JRFillParameter)pm.get("REPORT_TIME_ZONE");
        parameter_p_fecha_inicio = (JRFillParameter)pm.get("p_fecha_inicio");
        parameter_REPORT_DATA_SOURCE = (JRFillParameter)pm.get("REPORT_DATA_SOURCE");
        parameter_REPORT_LOCALE = (JRFillParameter)pm.get("REPORT_LOCALE");
        parameter_REPORT_URL_HANDLER_FACTORY = (JRFillParameter)pm.get("REPORT_URL_HANDLER_FACTORY");
        parameter_REPORT_PARAMETERS_MAP = (JRFillParameter)pm.get("REPORT_PARAMETERS_MAP");
        parameter_REPORT_CONNECTION = (JRFillParameter)pm.get("REPORT_CONNECTION");
        parameter_IS_IGNORE_PAGINATION = (JRFillParameter)pm.get("IS_IGNORE_PAGINATION");
        parameter_REPORT_VIRTUALIZER = (JRFillParameter)pm.get("REPORT_VIRTUALIZER");
        parameter_REPORT_SCRIPTLET = (JRFillParameter)pm.get("REPORT_SCRIPTLET");
        parameter_REPORT_MAX_COUNT = (JRFillParameter)pm.get("REPORT_MAX_COUNT");
    }


    /**
     *
     */
    private void initFields(Map fm)
    {
        field_nombre_empresa = (JRFillField)fm.get("nombre_empresa");
        field_plazo_gracia = (JRFillField)fm.get("plazo_gracia");
        field_numero_prestamo = (JRFillField)fm.get("numero_prestamo");
        field_tasa_intermediario = (JRFillField)fm.get("tasa_intermediario");
        field_tasa_foncrei = (JRFillField)fm.get("tasa_foncrei");
        field_regimen = (JRFillField)fm.get("regimen");
        field_nombre_entidad_financiera = (JRFillField)fm.get("nombre_entidad_financiera");
        field_id_entidad_financiera = (JRFillField)fm.get("id_entidad_financiera");
        field_monto_prestamo = (JRFillField)fm.get("monto_prestamo");
        field_fecha_acta_directorio = (JRFillField)fm.get("fecha_acta_directorio");
        field_plazo_amo = (JRFillField)fm.get("plazo_amo");
        field_saldo_deudor = (JRFillField)fm.get("saldo_deudor");
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
        variable_entidad_financiera_COUNT = (JRFillVariable)vm.get("entidad_financiera_COUNT");
        variable_v_sum_deuda_by_entidad_financiera = (JRFillVariable)vm.get("v_sum_deuda_by_entidad_financiera");
        variable_v_sum_deuda_by_report = (JRFillVariable)vm.get("v_sum_deuda_by_report");
        variable_v_regimen = (JRFillVariable)vm.get("v_regimen");
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_regimen.getValue()).booleanValue()== true?"Fijo":"Variable");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_entidad_financiera.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_entidad_financiera.getValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Total :  " + ((java.lang.String)field_nombre_entidad_financiera.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_entidad_financiera.getValue()));
                break;
            }
            case 21 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 25 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_gracia.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_regimen.getValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_acta_directorio.getValue()));
                break;
            }
            case 30 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_foncrei.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_prestamo.getValue()));
                break;
            }
            case 32 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 33 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_amo.getValue()));
                break;
            }
            case 34 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_intermediario.getValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_report.getValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getOldValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getOldValue()));
                break;
            }
            case 15 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_regimen.getOldValue()).booleanValue()== true?"Fijo":"Variable");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_entidad_financiera.getOldValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_entidad_financiera.getOldValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Total :  " + ((java.lang.String)field_nombre_entidad_financiera.getOldValue()));
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_entidad_financiera.getOldValue()));
                break;
            }
            case 21 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 25 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getOldValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getOldValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_gracia.getOldValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_regimen.getOldValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_acta_directorio.getOldValue()));
                break;
            }
            case 30 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_foncrei.getOldValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_prestamo.getOldValue()));
                break;
            }
            case 32 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getOldValue()));
                break;
            }
            case 33 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_amo.getOldValue()));
                break;
            }
            case 34 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_intermediario.getOldValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_report.getOldValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 4 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 5 : 
            {
                value = (java.lang.Integer)(new Integer(0));
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
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 13 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 14 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.math.BigDecimal)(new java.math.BigDecimal(0));
                break;
            }
            case 16 : 
            {
                value = (java.lang.String)(((java.lang.Boolean)field_regimen.getValue()).booleanValue()== true?"Fijo":"Variable");
                break;
            }
            case 17 : 
            {
                value = (java.lang.Object)(((java.lang.Integer)field_id_entidad_financiera.getValue()));
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_entidad_financiera.getValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)("Total :  " + ((java.lang.String)field_nombre_entidad_financiera.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_entidad_financiera.getEstimatedValue()));
                break;
            }
            case 21 : 
            {
                value = (java.lang.String)("logo_foncrei.jpg");
                break;
            }
            case 22 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 24 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 25 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_prestamo.getValue()));
                break;
            }
            case 26 : 
            {
                value = (java.lang.String)(((java.lang.String)field_nombre_empresa.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_gracia.getValue()));
                break;
            }
            case 28 : 
            {
                value = (java.lang.String)(((java.lang.String)variable_v_regimen.getEstimatedValue()));
                break;
            }
            case 29 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_acta_directorio.getValue()));
                break;
            }
            case 30 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_foncrei.getValue()));
                break;
            }
            case 31 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_monto_prestamo.getValue()));
                break;
            }
            case 32 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)field_saldo_deudor.getValue()));
                break;
            }
            case 33 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_plazo_amo.getValue()));
                break;
            }
            case 34 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_tasa_intermediario.getValue()));
                break;
            }
            case 35 : 
            {
                value = (java.math.BigDecimal)(((java.math.BigDecimal)variable_v_sum_deuda_by_report.getEstimatedValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}
