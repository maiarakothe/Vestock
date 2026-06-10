package br.edu.unoesc.vestock.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.ItemVenda;
import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.model.Venda;
import br.edu.unoesc.vestock.repository.ItemVendaRepository;
import br.edu.unoesc.vestock.repository.ProdutoRepository;
import br.edu.unoesc.vestock.repository.VendaRepository;

@Service
public class ItemVendaService {

	private final ItemVendaRepository itemVendaRepository;
	private final VendaRepository vendaRepository;
	private final ProdutoRepository produtoRepository;

	public ItemVendaService(ItemVendaRepository itemVendaRepository, VendaRepository vendaRepository,
			ProdutoRepository produtoRepository) {
		this.itemVendaRepository = itemVendaRepository;
		this.vendaRepository = vendaRepository;
		this.produtoRepository = produtoRepository;
	}

	/**
	 * Lista todos os itens de venda.
	 * 
	 * @return Uma lista de todos os itens de venda.
	 */
	public List<ItemVenda> listarTodos() {
		return itemVendaRepository.findAll();
	}

	/**
	 * Busca um item de venda pelo seu ID.
	 * 
	 * @param id O ID do item de venda a ser buscado.
	 * @return O item de venda encontrado.
	 * @throws RuntimeException Se o ItemVenda não for encontrado.
	 */
	public ItemVenda buscarPorId(Integer id) {
		Optional<ItemVenda> item = itemVendaRepository.findById(id);
		if (item.isPresent()) {
			return item.get();
		} else {
			throw new RuntimeException("ItemVenda não encontrado: " + id);
		}
	}

	/**
	 * Cria um novo item de venda, valida a existência da venda e do produto,
	 * calcula o valor total e o salva.
	 * 
	 * @param item O item de venda a ser criado.
	 * @return O item de venda salvo.
	 * @throws RuntimeException Se a venda ou o produto não forem encontrados.
	 */
	public ItemVenda criarItemVenda(ItemVenda item) {

		Optional<Venda> vendaOpt = vendaRepository.findById(item.getVenda().getId());
		if (!vendaOpt.isPresent()) {
			throw new RuntimeException("Venda não encontrada");
		}

		Optional<Produto> produtoOpt = produtoRepository.findById(item.getProduto().getId());
		if (!produtoOpt.isPresent()) {
			throw new RuntimeException("Produto não encontrado");
		}

		Venda venda = vendaOpt.get();
		Produto produto = produtoOpt.get();

		item.setVenda(venda);
		item.setProduto(produto);

		// Calcula valor total do item
		BigDecimal qtd = new BigDecimal(item.getQuantidadeItem());
		BigDecimal total = produto.getVenda().multiply(qtd);

		item.setValorUnitario(produto.getVenda());
		item.setValorTotal(total);

		return itemVendaRepository.save(item);
	}

	/**
	 * Atualiza um item de venda existente, recalcula seu valor total e salva.
	 * 
	 * @param id   O ID do item de venda a ser atualizado.
	 * @param novo O objeto item de venda com os novos dados.
	 * @return O item de venda atualizado.
	 * @throws RuntimeException Se o ItemVenda ou o Produto não forem encontrados.
	 */
	public ItemVenda atualizarItemVenda(Integer id, ItemVenda novo) {
		Optional<ItemVenda> itemOpt = itemVendaRepository.findById(id);
		if (!itemOpt.isPresent()) {
			throw new RuntimeException("ItemVenda não encontrado: " + id);
		}

		ItemVenda item = itemOpt.get();

		Optional<Produto> produtoOpt = produtoRepository.findById(novo.getProduto().getId());
		if (!produtoOpt.isPresent()) {
			throw new RuntimeException("Produto não encontrado");
		}

		Produto produto = produtoOpt.get();

		item.setQuantidadeItem(novo.getQuantidadeItem());
		item.setProduto(produto);

		BigDecimal qtd = new BigDecimal(item.getQuantidadeItem());
		item.setValorUnitario(produto.getVenda());
		item.setValorTotal(produto.getVenda().multiply(qtd));

		return itemVendaRepository.save(item);
	}

	/**
	 * Deleta um item de venda pelo seu ID.
	 * 
	 * @param id O ID do item de venda a ser deletado.
	 * @throws RuntimeException Se o ItemVenda não for encontrado.
	 */
	public void deletarItemVenda(Integer id) {
		if (!itemVendaRepository.existsById(id)) {
			throw new RuntimeException("ItemVenda não encontrado: " + id);
		}
		itemVendaRepository.deleteById(id);
	}
}