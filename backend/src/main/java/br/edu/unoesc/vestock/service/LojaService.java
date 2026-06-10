package br.edu.unoesc.vestock.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.repository.LojaRepository;

@Service
public class LojaService {

	private final LojaRepository lojaRepository;

	public LojaService(LojaRepository lojaRepository) {
		this.lojaRepository = lojaRepository;
	}

	/**
	 * Lista todas as lojas.
	 * 
	 * @return Uma lista de todas as lojas.
	 */
	public List<Loja> listarTodos() {
		return lojaRepository.findAll();
	}

	/**
	 * Busca uma loja pelo seu ID.
	 * 
	 * @param id O ID da loja a ser buscada.
	 * @return A loja encontrada.
	 * @throws RuntimeException Se a loja não for encontrada.
	 */
	public Loja buscarPorId(Integer id) {
		Optional<Loja> loja = lojaRepository.findById(id);

		if (loja.isPresent()) {
			return loja.get();
		} else {
			throw new RuntimeException("Loja não encontrada: " + id);
		}
	}

	/**
	 * Cria uma nova loja.
	 * 
	 * @param loja A loja a ser criada.
	 * @return A loja salva.
	 */
	public Loja criarLoja(Loja loja) {
		return lojaRepository.save(loja);
	}

	/**
	 * Atualiza uma loja existente com novos dados.
	 * 
	 * @param id       O ID da loja a ser atualizada.
	 * @param novaLoja O objeto loja com os novos dados.
	 * @return A loja atualizada.
	 * @throws RuntimeException Se a loja não for encontrada.
	 */
	public Loja atualizarLoja(Integer id, Loja novaLoja) {
		Loja loja = buscarPorId(id);
		loja.setNome(novaLoja.getNome());
		loja.setRua(novaLoja.getRua());
		loja.setBairro(novaLoja.getBairro());
		loja.setCidade(novaLoja.getCidade());
		loja.setTelefone(novaLoja.getTelefone());
		loja.setCnpj(novaLoja.getCnpj());

		return lojaRepository.save(loja);
	}

	/**
	 * Deleta uma loja pelo seu ID.
	 * 
	 * @param id O ID da loja a ser deletada.
	 * @throws RuntimeException Se a loja não for encontrada.
	 */
	public void deletarLoja(Integer id) {
		if (!lojaRepository.existsById(id)) {
			throw new RuntimeException("Loja não encontrada: " + id);
		}
		lojaRepository.deleteById(id);
	}
}