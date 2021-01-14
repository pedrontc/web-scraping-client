# Para usar a Gem mechanize
require 'mechanize' 

# Instancia para usarmos o objeto e interagir com a página.
agent = Mechanize.new 

# Para baixar as informações da página
page = agent.get('http://localhost:3000') 
## p page # Caso queira imprimirmos o resultado

# Para selecionar o form da página
login_form = page.form 

# Os duas linhas login_form de código servem para preencher os campos de login
login_form.field_with(name: 'user[email]').value = 'example@example.com' 
login_form.field_with(name: 'user[password]').value = '123456'

# Para submeter o login e pegar a página de resultado
product_list_page = agent.submit(login_form) 

# Para criar um arquivo e incluir um título nele
out_file = File.new('product_list.txt', 'w') 
out_file.puts 'Prodct List:'

# Loop em para checar todas as paginás a menos que o unless no final do loop seja true
loop do 

  # Para pegar a tag tr dentro da tag tbody
    product_list_page.search('tbody tr').each do |p|  

      # Pegar cada TD dentro de cara tbody com tr que for encontrado no loop
      f = p.search('td') 

      # As linhas de código a baixo são para pegar cada indice da lista pega pelo loop e imprimir de forma amigavel uma ao lado da outra.
      line = "title: #{f[0].text} | "
      line += "brand: #{f[1].text} | "
      line += "description: #{f[2].text} | "
      line += "price: #{f[3].text}"
      out_file.puts line
    end
    
    # Para parar caso nao exista um link com texto 'Next >' ná página.
    break unless product_list_page.link_with(text: 'Next ›') 
    
    # Caso tenha um link com texto 'Next >' essa linha de cógido clica no link e guarda esse resultado de volta na mesma variável onde estava, assim atualizando a página no próximo laço.
    product_list_page = product_list_page.link_with(text: 'Next ›').click 
end

out_file.close