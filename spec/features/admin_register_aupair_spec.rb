require 'rails_helper'

feature 'Admin register AuPair' do
  scenario 'successfully' do
    visit root_path
    click_on 'Cadastrar Babá'

    fill_in 'Nome', with: 'Super Nanny'
    fill_in 'Email', with: 'nany@milababies.com'
    fill_in 'Telefone', with: '(11) 1234-5678'
    fill_in 'CPF', with: '123456789-00'
    fill_in 'Habilidades', with: 'Brincadeiras lúdicas em Português e Alemão'
    fill_in 'Formação', with: 'Superior Completo em Letras'
    fill_in 'Idiomas', with: 'Português Nativo, Alemão Avançado e Inglês Básico'
    fill_in 'Data de Nascimento', with: '01/01/1990'
    fill_in 'Cidade', with: 'São Paulo'
    click_on 'Enviar'

    au_pair = AuPair.last
    expect(page).to have_css('h1', text: 'Super Nanny')
    expect(page).to have_css('em', text: 'nany@milababies.com')
    expect(page).to have_css('dd', text: '(11) 1234-5678')
    expect(page).to have_css('dd', text: '01/01/1990')
    expect(current_path).to eq au_pair_path(au_pair.id)
  end

  scenario 'and must fill in all fields' do
    visit root_path
    click_on 'Cadastrar Babá'

    fill_in 'Nome', with: ''
    fill_in 'Email', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Cadastrar Nova Babá')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'and cannot register with duplicate CPF' do
    create(:au_pair, cpf: '12345678900')

    visit root_path
    click_on 'Cadastrar Babá'

    fill_in 'Nome', with: 'Super Nanny'
    fill_in 'Email', with: 'nany@milababies.com'
    fill_in 'Telefone', with: '(11) 1234-5678'
    fill_in 'CPF', with: '12345678900'
    fill_in 'Habilidades', with: 'Brincadeiras lúdicas em Português e Alemão'
    fill_in 'Formação', with: 'Superior Completo em Letras'
    fill_in 'Idiomas', with: 'Português Nativo, Alemão Avançado e Inglês Básico'
    fill_in 'Data de Nascimento', with: '01/01/1990'
    fill_in 'Cidade', with: 'São Paulo'
    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Cadastrar Nova Babá')
    expect(page).to have_content('CPF já está em uso')
  end
end