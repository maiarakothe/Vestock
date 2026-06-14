package br.edu.unoesc.vestock.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Condicional;
import br.edu.unoesc.vestock.model.ItemCondicional;
import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.repository.CondicionalRepository;
import br.edu.unoesc.vestock.repository.LojaRepository;
import br.edu.unoesc.vestock.repository.ProdutoRepository;

@Service
public class CondicionalService {

	private final CondicionalRepository condicionalRepository;
	private final ProdutoRepository produtoRepository;
	private final LojaRepository lojaRepository;

	public CondicionalService(CondicionalRepository condicionalRepository, ProdutoRepository produtoRepository,
			LojaRepository lojaRepository) {
		this.condicionalRepository = condicionalRepository;
		this.produtoRepository = produtoRepository;
		this.lojaRepository = lojaRepository;
	}

	/**
	 * Lista todas as condicionais.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de todas as condicionais.
	 */
	public List<Condicional> listarTodos(Integer lojaId) {
		return condicionalRepository.findByLojaId(lojaId);
	}

	/**
	 * Busca uma condicional pelo seu ID.
	 * 
	 * @param id O ID da condicional a ser buscada.
	 * @return A condicional encontrada.
	 * @throws RuntimeException Se a condicional não for encontrada.
	 */
	public Condicional buscarPorId(Integer id) {
		Optional<Condicional> condicional = condicionalRepository.findById(id);

		if (condicional.isPresent()) {
			return condicional.get();
		} else {
			throw new RuntimeException("Condicional não encontrada: " + id);
		}
	}

	/**
	 * Valida se a data de devolução é posterior à data de retirada.
	 * 
	 * @param condicional A condicional a ser validada.
	 * @throws RuntimeException Se a data de devolução não for depois da data de
	 *                          retirada.
	 */
	private void validarDatas(Condicional condicional) {
		if (condicional.getDataRetirada() == null || condicional.getDataDevolucao() == null) {
			return;
		}

		if (!condicional.getDataDevolucao().isAfter(condicional.getDataRetirada())) {
			throw new RuntimeException("A data de devolução deve ser DEPOIS da data de retirada.");
		}
	}

	/**
	 * Cria uma nova condicional, valida as datas, define como não devolvida,
	 * subtrai os itens do estoque e salva a condicional.
	 * 
	 * @param condicional A condicional a ser criada.
	 * @return A condicional salva.
	 * @throws RuntimeException Se um produto não for encontrado ou se o estoque for
	 *                          insuficiente.
	 */
	public Condicional criarCondicional(Condicional condicional) {

		validarDatas(condicional);

		if (condicional.getLoja() == null || condicional.getLoja().getId() == null) {
			throw new RuntimeException("Loja é obrigatória para criar uma condicional");
		}

		Loja loja = lojaRepository.findById(condicional.getLoja().getId())
				.orElseThrow(() -> new RuntimeException("Loja não encontrada: " + condicional.getLoja().getId()));

		condicional.setLoja(loja);

		condicional.setDevolvido(false);

		if (condicional.getItens() != null) {
			for (ItemCondicional item : condicional.getItens()) {

				Produto produto = produtoRepository.findById(item.getProduto().getId())
						.orElseThrow(() -> new RuntimeException("Produto não encontrado"));

				if (produto.getQuantidadeEstoque() < item.getQuantidadeItem()) {
					throw new RuntimeException("Estoque insuficiente para o produto: " + produto.getNome());
				}

				produto.setQuantidadeEstoque(produto.getQuantidadeEstoque() - item.getQuantidadeItem());
				produtoRepository.save(produto);

				item.setCondicional(condicional);
			}
		}

		return condicionalRepository.save(condicional);
	}

	/**
	 * Atualiza uma condicional existente, devolvendo os itens antigos ao estoque,
	 * validando as datas e subtraindo os novos itens do estoque.
	 * 
	 * @param id              O ID da condicional a ser atualizada.
	 * @param novaCondicional O objeto condicional com os novos dados.
	 * @return A condicional atualizada.
	 * @throws RuntimeException Se a condicional ou um produto não for encontrado,
	 *                          se as datas forem inválidas, ou se o estoque for
	 *                          insuficiente.
	 */
	public Condicional atualizarCondicional(Integer id, Condicional novaCondicional) {

		Condicional antiga = buscarPorId(id);
		validarDatas(novaCondicional);

		// Devolver ao estoque atual
		if (antiga.getItens() != null) {
			for (ItemCondicional itemAntigo : antiga.getItens()) {

				Produto produto = produtoRepository.findById(itemAntigo.getProduto().getId()).orElse(null);

				if (produto != null) {
					produto.setQuantidadeEstoque(produto.getQuantidadeEstoque() + itemAntigo.getQuantidadeItem());
					produtoRepository.save(produto);
				}
			}
		}

		antiga.getItens().clear();

		// Subtrair para os novos itens adicionados
		if (novaCondicional.getItens() != null) {
			for (ItemCondicional itemNovo : novaCondicional.getItens()) {

				Produto produto = produtoRepository.findById(itemNovo.getProduto().getId())
						.orElseThrow(() -> new RuntimeException("Produto não encontrado"));

				if (produto.getQuantidadeEstoque() < itemNovo.getQuantidadeItem()) {
					throw new RuntimeException("Estoque insuficiente para o produto: " + produto.getNome());
				}

				// Subtrair do estoque
				produto.setQuantidadeEstoque(produto.getQuantidadeEstoque() - itemNovo.getQuantidadeItem());
				produtoRepository.save(produto);

				itemNovo.setCondicional(antiga);
				antiga.getItens().add(itemNovo);
			}
		}

		antiga.setNomeItem(novaCondicional.getNomeItem());
		antiga.setDataRetirada(novaCondicional.getDataRetirada());
		antiga.setDataDevolucao(novaCondicional.getDataDevolucao());
		antiga.setObservacao(novaCondicional.getObservacao());
		antiga.setCliente(novaCondicional.getCliente());

		return condicionalRepository.save(antiga);
	}

	/**
	 * Marca uma condicional como devolvida, atualiza a data de devolução para o
	 * momento atual e adiciona os itens de volta ao estoque.
	 * 
	 * @param id O ID da condicional a ser marcada como devolvida.
	 * @return A condicional atualizada.
	 * @throws RuntimeException Se a condicional não for encontrada ou já estiver
	 *                          devolvida.
	 */
	public Condicional marcarComoDevolvido(Integer id) {

		Condicional condicional = buscarPorId(id);

		if (condicional.getDevolvido() != null && condicional.getDevolvido()) {
			throw new RuntimeException("Condicional já devolvida.");
		}

		condicional.setDevolvido(true);
		condicional.setDataDevolucao(LocalDateTime.now());

		// Somar estoque de volta
		if (condicional.getItens() != null) {
			for (ItemCondicional item : condicional.getItens()) {

				Produto produto = produtoRepository.findById(item.getProduto().getId()).orElse(null);

				if (produto != null) {
					produto.setQuantidadeEstoque(produto.getQuantidadeEstoque() + item.getQuantidadeItem());
					produtoRepository.save(produto);
				}
			}
		}

		return condicionalRepository.save(condicional);
	}

	/**
	 * Deleta uma condicional pelo seu ID.
	 * 
	 * @param id O ID da condicional a ser deletada.
	 */
	public void deletarCondicional(Integer id) {
		condicionalRepository.deleteById(id);
	}

	/**
	 * Conta o número de condicionais que não foram devolvidas (ativas).
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return O número de condicionais ativas.
	 */
	public long contarCondicionaisAtivas(Integer lojaId) {
		return condicionalRepository.countByLojaIdAndDevolvidoFalse(lojaId);
	}

	/**
	 * Lista as condicionais ativas (não devolvidas) que vencem na data de hoje.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de condicionais vencendo hoje.
	 */
	public List<Condicional> listarCondicionaisVencendoHoje(Integer lojaId) {
		LocalDate hoje = LocalDate.now();
		return condicionalRepository.findByLojaIdAndDataDevolucaoBetweenAndDevolvidoFalse(lojaId,
				hoje.atStartOfDay(), hoje.atTime(LocalTime.MAX));
	}
}