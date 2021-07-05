class EnviarCorreo < ActionMailer::Base

  default from: "gprotec@gprotec.com"

  def enviar_correo(user, body, aviso)
    logger.info "Enviar correo ======> "
    mail(to: user,
         body: body,
         content_type: "text/html",
         subject: aviso)
    # encoded_content = self.SpecialEncode(body)

    # attachments['aviso_cobranzas'] = {:mime_type => 'application/x-gzip',
    #                                :encoding => 'SpecialEncoding',
    #                                :content => encoded_content }

    # @user=user
    # @url="http://example.com/login"
    # mail(:to=>user,:subject =>aviso)
  end

end
