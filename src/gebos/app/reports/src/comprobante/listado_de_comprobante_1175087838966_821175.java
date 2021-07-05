/*
 * Generated by JasperReports - 3/28/07 9:17 AM
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
public class listado_de_comprobante_1175087838966_821175 extends JREvaluator
{


    /**
     *
     */
    private JRFillParameter parameter_REPORT_RESOURCE_BUNDLE = null;
    private JRFillParameter parameter_p_id_cliente = null;
    private JRFillParameter parameter_REPORT_DATE_FORMAT_FACTORY = null;
    private JRFillParameter parameter_p_fecha = null;
    private JRFillParameter parameter_REPORT_CLASS_LOADER = null;
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
    private JRFillField field_numero_comprobante = null;
    private JRFillField field_id_cuenta_contable = null;
    private JRFillField field_fecha_registro = null;
    private JRFillField field_id_prestamo = null;
    private JRFillField field_haber = null;
    private JRFillField field_id_cliente = null;
    private JRFillField field_id_comprobante_contable = null;
    private JRFillField field_fecha_comprobante = null;
    private JRFillField field_id_cuenta_contable_presupuesto = null;
    private JRFillField field_cuenta_presupuesto = null;
    private JRFillField field_cuenta_contable = null;
    private JRFillField field_debe = null;
    private JRFillField field_numero_contrato = null;
    private JRFillVariable variable_PAGE_NUMBER = null;
    private JRFillVariable variable_COLUMN_NUMBER = null;
    private JRFillVariable variable_REPORT_COUNT = null;
    private JRFillVariable variable_PAGE_COUNT = null;
    private JRFillVariable variable_COLUMN_COUNT = null;


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
        parameter_p_id_cliente = (JRFillParameter)pm.get("p_id_cliente");
        parameter_REPORT_DATE_FORMAT_FACTORY = (JRFillParameter)pm.get("REPORT_DATE_FORMAT_FACTORY");
        parameter_p_fecha = (JRFillParameter)pm.get("p_fecha");
        parameter_REPORT_CLASS_LOADER = (JRFillParameter)pm.get("REPORT_CLASS_LOADER");
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
        field_numero_comprobante = (JRFillField)fm.get("numero_comprobante");
        field_id_cuenta_contable = (JRFillField)fm.get("id_cuenta_contable");
        field_fecha_registro = (JRFillField)fm.get("fecha_registro");
        field_id_prestamo = (JRFillField)fm.get("id_prestamo");
        field_haber = (JRFillField)fm.get("haber");
        field_id_cliente = (JRFillField)fm.get("id_cliente");
        field_id_comprobante_contable = (JRFillField)fm.get("id_comprobante_contable");
        field_fecha_comprobante = (JRFillField)fm.get("fecha_comprobante");
        field_id_cuenta_contable_presupuesto = (JRFillField)fm.get("id_cuenta_contable_presupuesto");
        field_cuenta_presupuesto = (JRFillField)fm.get("cuenta_presupuesto");
        field_cuenta_contable = (JRFillField)fm.get("cuenta_contable");
        field_debe = (JRFillField)fm.get("debe");
        field_numero_contrato = (JRFillField)fm.get("numero_contrato");
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_comprobante.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_comprobante.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_registro.getValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_contrato.getValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_contable.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_presupuesto.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.String)(null);
                break;
            }
            case 26 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_debe.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_haber.getValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_comprobante.getOldValue()));
                break;
            }
            case 14 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_comprobante.getOldValue()));
                break;
            }
            case 15 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_registro.getOldValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_contrato.getOldValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getOldValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_contable.getOldValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_presupuesto.getOldValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.String)(null);
                break;
            }
            case 26 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_debe.getOldValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_haber.getOldValue()));
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
                value = (java.util.Date)(new java.sql.Date(2006,1,1));
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
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 8 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 9 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 10 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 11 : 
            {
                value = (java.lang.Integer)(new Integer(1));
                break;
            }
            case 12 : 
            {
                value = (java.lang.Integer)(new Integer(0));
                break;
            }
            case 13 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_comprobante.getValue()));
                break;
            }
            case 14 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_comprobante.getValue()));
                break;
            }
            case 15 : 
            {
                value = (java.util.Date)(((java.sql.Date)field_fecha_registro.getValue()));
                break;
            }
            case 16 : 
            {
                value = (java.lang.Integer)(((java.lang.Integer)field_numero_contrato.getValue()));
                break;
            }
            case 17 : 
            {
                value = (java.lang.String)("./logo_foncrei.jpg");
                break;
            }
            case 18 : 
            {
                value = (java.lang.String)("Pag. " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 19 : 
            {
                value = (java.lang.String)(" / " + ((java.lang.Integer)variable_PAGE_NUMBER.getEstimatedValue()));
                break;
            }
            case 20 : 
            {
                value = (java.util.Date)(new Date());
                break;
            }
            case 21 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_desde.getValue()));
                break;
            }
            case 22 : 
            {
                value = (java.util.Date)(((java.util.Date)parameter_p_fecha_hasta.getValue()));
                break;
            }
            case 23 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_contable.getValue()));
                break;
            }
            case 24 : 
            {
                value = (java.lang.String)(((java.lang.String)field_cuenta_presupuesto.getValue()));
                break;
            }
            case 25 : 
            {
                value = (java.lang.String)(null);
                break;
            }
            case 26 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_debe.getValue()));
                break;
            }
            case 27 : 
            {
                value = (java.lang.Double)(((java.lang.Double)field_haber.getValue()));
                break;
            }
           default :
           {
           }
        }
        
        return value;
    }


}