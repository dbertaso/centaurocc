module RjReport

  def generate_report(report_design, parameters, output_type, group_reports)
    report_design << '.jasper' if !report_design.match(/\.jasper$/)

    case "linux"
    when /mswin32/
      sep = ";"
    else
      sep = ":"
    end
    interface_classpath = ""
    folder_reports = root_path + "/app/reports/bin/#{group_reports}"
    interface_classpath << folder_reports
    
    str_parameters = parse_parameters(parameters)

    Dir.foreach(File.dirname(__FILE__) + "/java") do |file|
      interface_classpath << "#{sep}#{File.dirname(__FILE__)}/java/"+file if (file != '.' and file != '..' and file.match(/.jar/))
    end
    logger.info "PARAMETROS "+str_parameters.inspect
    logger.info "------------------------------------------------"
    logger.info "ambiente: " "#{ENV['RAILS_ENV']}"
    
#    logger.info "/java/jdk1.5.0_10/bin/java -cp \"#{interface_classpath}\" JasperInterface -o#{output_type} -d#{folder_reports}/#{report_design} -f#{root_path}/config/database.yml -eproduction"
cmd = "java -cp \"#{interface_classpath}\" JasperInterface -o#{output_type} -d#{folder_reports}/#{report_design} -f#{root_path}/config/database.yml -e#{ENV['RAILS_ENV']}"      
logger.info cmd
pipe = IO.popen cmd, "w+b" 
#    pipe = IO.popen "/java/jdk1.5.0_10/bin/java -cp \"#{interface_classpath}\" JasperInterface -o#{output_type} -d#{folder_reports}/#{report_design} -f#{root_path}/config/database.yml -e#{ENV['RAILS_ENV']}", "w+b" 
    pipe.write str_parameters
    pipe.close_write
    result = pipe.read
    pipe.close
    #logger.info "RESULT ========> " << result.to_s
    return result
  end
  
  def parse_parameters(parameters)
    str = "";
    parameters.each {|key, value| str += key.to_s + ":" + value[0].to_s + ":" + value[1].to_s + "\n" }

    return str
  end
  
  def cache_hack
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
  end

  def send_doc(design, parameters, folder, file_name, output_type = 'pdf' )

    case output_type
    when 'rtf'
      extension = 'rtf'
      mime_type = 'application/rtf'
      jasper_type = 'rtf'
    else # pdf
      extension = 'pdf'
      mime_type = 'application/pdf'
      jasper_type = 'pdf'
    end

    cache_hack
    send_data generate_report(design, parameters, output_type, folder),
        :filename => "#{file_name}.#{extension}", :type => mime_type, :disposition => 'inline'
  end
  
  def write_doc(design, parameters, folder, file_name, output_type = 'pdf')

    path_file = root_path + "/" + file_name.to_s + "." + output_type
    file = File.new(path_file, File::CREAT|File::TRUNC|File::RDWR, 0644)
    contenido = generate_report(design, parameters, output_type, folder)
    file.<< contenido
    #logger.debug "CONTENIDO: "
    #logger.debug contenido
    file.close
    
    return true;
  
  end
  
  def open_and_send_doc(file_name, output_type = 'pdf' )
    case output_type
    when 'rtf'
      extension = 'rtf'
      mime_type = 'application/rtf'
      jasper_type = 'rtf'
    else # pdf
      extension = 'pdf'
      mime_type = 'application/pdf'
      jasper_type = 'pdf'
    end

    path_file = root_path + "/" + file_name + "." + extension
    file = File.open(path_file)
    
    result = ""
    while (line = file.gets)
        result.<< line
    end

    cache_hack
    send_data result,
        :filename => "#{file_name}.#{extension}", :type => mime_type, :disposition => 'inline'
  end
  
  private
  def root_path()
    _root_path = Dir.getwd;
    _root_path += "/.." if _root_path=~ /\/public/
    _root_path
  end

end
