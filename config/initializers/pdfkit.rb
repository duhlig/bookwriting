# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  config.wkhtmltopdf = './vendor/wkhtmltopdf/wkhtmltopdf.exe'
  config.default_options = {
      :page_size => 'Legal',
      :print_media_type => true
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = "http://localhost:3000"
end