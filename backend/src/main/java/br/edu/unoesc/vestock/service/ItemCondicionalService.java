package br.edu.unoesc.vestock.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.ItemCondicional;
import br.edu.unoesc.vestock.repository.ItemCondicionalRepository;

@Service
public class ItemCondicionalService {

	private final ItemCondicionalRepository itemRepository;

	public ItemCondicionalService(ItemCondicionalRepository itemRepository) {
		this.itemRepository = itemRepository;
	}

	/**
	 * Lista todos os itens de condicional.
	 * 
	 * @return Uma lista de todos os itens de condicional.
	 */
	public List<ItemCondicional> listarTodos() {
		return itemRepository.findAll();
	}

	/**
	 * Busca um item de condicional pelo seu ID.
	 * 
	 * @param id O ID do item de condicional a ser buscado.
	 * @return O item de condicional encontrado.
	 * @throws RuntimeException Se o item condicional não for encontrado.
	 */
	public ItemCondicional buscarPorId(Integer id) {
		Optional<ItemCondicional> itemCondicional = itemRepository.findById(id);

		if (itemCondicional.isPresent()) {
			return itemCondicional.get();
		} else {
			throw new RuntimeException("Item condicional não encontrado: " + id);
		}
	}

	/**
	 * Cria um novo item de condicional.
	 * 
	 * @param item O item de condicional a ser criado.
	 * @return O item de condicional salvo.
	 */
	public ItemCondicional criarItem(ItemCondicional item) {
		return itemRepository.save(item);
	}

	/**
	 * Atualiza um item de condicional existente com novos dados.
	 * 
	 * @param id       O ID do item de condicional a ser atualizado.
	 * @param novoItem O objeto item de condicional com os novos dados.
	 * @return O item de condicional atualizado.
	 * @throws RuntimeException Se o item condicional não for encontrado.
	 */
	public ItemCondicional atualizarItem(Integer id, ItemCondicional novoItem) {
		ItemCondicional item = buscarPorId(id);

		item.setQuantidadeItem(novoItem.getQuantidadeItem());
		item.setCondicional(novoItem.getCondicional());
		item.setProduto(novoItem.getProduto());

		return itemRepository.save(item);
	}

	/**
	 * Deleta um item de condicional pelo seu ID.
	 * 
	 * @param id O ID do item de condicional a ser deletado.
	 * @throws RuntimeException Se o item condicional não for encontrado.
	 */
	public void deletarItem(Integer id) {
		if (!itemRepository.existsById(id)) {
			throw new RuntimeException("Item condicional não encontrado: " + id);
		}
		itemRepository.deleteById(id);
	}
}