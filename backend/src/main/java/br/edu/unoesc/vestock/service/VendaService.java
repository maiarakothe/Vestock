package br.edu.unoesc.vestock.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Desconto;
import br.edu.unoesc.vestock.model.ItemVenda;
import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.model.Venda;
import br.edu.unoesc.vestock.repository.DescontoRepository;
import br.edu.unoesc.vestock.repository.ProdutoRepository;
import br.edu.unoesc.vestock.repository.VendaRepository;

@Service
public class VendaService {

	private final VendaRepository vendaRepository;
	private final DescontoRepository descontoRepository;
	private final ProdutoRepository produtoRepository;

	public VendaService(VendaRepository vendaRepository, DescontoRepository descontoRepository,
			ProdutoRepository produtoRepository) {
		this.vendaRepository = vendaRepository;
		this.descontoRepository = descontoRepository;
		this.produtoRepository = produtoRepository;
	}

	/**
	 * Lista todas as vendas.
	 * 
	 * @return Uma lista de todas as vendas.
	 */
	public List<Venda> listarTodos() {
		return vendaRepository.findAll();
	}

	/**
	 * Busca uma venda pelo seu ID.
	 * 
	 * @param id O ID da venda a ser buscada.
	 * @return A venda encontrada.
	 * @throws RuntimeException Se a venda não for encontrada.
	 */
	public Venda buscarPorId(Integer id) {
		Optional<Venda> vendaOpt = vendaRepository.findById(id);
		if (vendaOpt.isPresent()) {
			return vendaOpt.get();
		} else {
			throw new RuntimeException("Venda não encontrada: " + id);
		}
	}

	/**
	 * Cria uma nova venda, processa os itens de venda (calcula valores, atualiza
	 * estoque), aplica o desconto (se houver) e calcula o valor total.
	 * 
	 * @param venda A venda a ser criada.
	 * @return A venda salva.
	 * @throws RuntimeException Se um produto ou desconto não for encontrado, ou se
	 *                          o estoque for insuficiente.
	 */
	public Venda criarVenda(Venda venda) {
		List<ItemVenda> itensRecebidos = new ArrayList<>(venda.getItens());
		venda.getItens().clear();

		BigDecimal subtotalItens = BigDecimal.ZERO;

		for (ItemVenda item : itensRecebidos) {
			Optional<Produto> produtoOpt = produtoRepository.findById(item.getProduto().getId());
			if (!produtoOpt.isPresent()) {
				throw new RuntimeException("Produto não encontrado");
			}
			Produto produto = produtoOpt.get();

			// Calcula valor do item
			BigDecimal qtd = new BigDecimal(item.getQuantidadeItem());
			BigDecimal valorUnitario = produto.getVenda();
			BigDecimal valorTotal = valorUnitario.multiply(qtd);

			item.setValorUnitario(valorUnitario);
			item.setValorTotal(valorTotal);
			item.setProduto(produto);

			// Atualiza estoque
			int novoEstoque = produto.getQuantidadeEstoque() - item.getQuantidadeItem();
			if (novoEstoque < 0) {
				throw new RuntimeException("Estoque insuficiente para o produto: " + produto.getNome());
			}
			produto.setQuantidadeEstoque(novoEstoque);
			produtoRepository.save(produto);

			subtotalItens = subtotalItens.add(valorTotal);

			venda.addItemVenda(item);
		}

		// Aplica desconto
		BigDecimal descontoAplicado = BigDecimal.ZERO;
		if (venda.getDesconto() != null && venda.getDesconto().getId() != null) {
			Optional<Desconto> descontoOpt = descontoRepository.findById(venda.getDesconto().getId());
			if (!descontoOpt.isPresent()) {
				throw new RuntimeException("Desconto não encontrado");
			}
			venda.setDesconto(descontoOpt.get());

			if (venda.getDesconto().getValor() != null) {
				descontoAplicado = subtotalItens
						.multiply(venda.getDesconto().getValor().divide(BigDecimal.valueOf(100)));
			}
		}

		venda.setDataVenda(LocalDateTime.now());
		venda.setValorCupomDesconto(descontoAplicado);
		venda.setTotalVenda(subtotalItens.subtract(descontoAplicado).max(BigDecimal.ZERO));

		return vendaRepository.save(venda);
	}

	// Procedure que lista todas as vendas que utilizaram cupons de desconto e os
	// valores finais com os descontos.
	/**
	 * Calcula o valor total após a aplicação de um desconto percentual.
	 * 
	 * @param total    O valor total original.
	 * @param desconto O percentual de desconto a ser aplicado.
	 * @return O valor final com o desconto aplicado (chama uma procedure do
	 *         repositório).
	 */
	public BigDecimal calcularDesconto(BigDecimal total, BigDecimal desconto) {
		return vendaRepository.aplicarDesconto(total, desconto);
	}

}