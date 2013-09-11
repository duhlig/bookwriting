# config/initializers/wicked_pdf.rb
  WickedPdf.config = {
      #:exe_path => '/usr/local/bin/wkhtmltopdf'
      :wkhtmltopdf => './vendor/wkhtmltopdf/wkhtmltopdf.exe',
      #:layout => "pdf.html",
      :margin => {    :top=> 20,
                      :bottom => 20,
                      :left=> 30,
                      :right => 30},
      #:header => {:html => { :template=> 'layouts/pdf_header.html'}},
      #:footer => {:html => { :template=> 'layouts/pdf_footer.html'}}
      #:exe_path => '/usr/bin/wkhtmltopdf'
  }