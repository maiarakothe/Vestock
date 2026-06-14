package br.edu.unoesc.vestock.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.repository.ProdutoRepository;
import br.edu.unoesc.vestock.repository.LojaRepository;

@Service
public class ProdutoService {

	private final ProdutoRepository produtoRepository;
	private final LojaRepository lojaRepository;

	public ProdutoService(ProdutoRepository produtoRepository, LojaRepository lojaRepository) {
		this.produtoRepository = produtoRepository;
		this.lojaRepository = lojaRepository;
	}

	/**
	 * Lista todos os produtos.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de todos os produtos.
	 */
	public List<Produto> listarTodos(Integer lojaId) {
		return produtoRepository.findByLojaId(lojaId);
	}

	/**
	 * Busca um produto pelo seu ID.
	 * 
	 * @param id O ID do produto a ser buscado.
	 * @return O produto encontrado.
	 * @throws RuntimeException Se o produto não for encontrado.
	 */
	public Produto buscarPorId(Integer id) {
		Optional<Produto> produto = produtoRepository.findById(id);

		if (produto.isPresent()) {
			return produto.get();
		} else {
			throw new RuntimeException("Produto não encontrado: " + id);
		}
	}

	/**
	 * Cria um novo produto.
	 * 
	 * @param produto O produto a ser criado.
	 * @return O produto salvo.
	 */
	public Produto criarProduto(Produto produto) {
		if (produto.getLoja() == null || produto.getLoja().getId() == null) {
			throw new RuntimeException("Loja é obrigatória para cadastrar um produto");
		}

		Loja loja = lojaRepository.findById(produto.getLoja().getId())
				.orElseThrow(() -> new RuntimeException("Loja não encontrada: " + produto.getLoja().getId()));

		produto.setLoja(loja);
		return produtoRepository.save(produto);
	}

	/**
	 * Atualiza um produto existente com novos dados.
	 * 
	 * @param id          O ID do produto a ser atualizado.
	 * @param novaProduto O objeto produto com os novos dados.
	 * @return O produto atualizado.
	 * @throws RuntimeException Se o produto não for encontrado.
	 */
	public Produto atualizarProduto(Integer id, Produto novaProduto) {
		Produto produto = buscarPorId(id);

		produto.setNome(novaProduto.getNome());
		produto.setTamanho(novaProduto.getTamanho());
		produto.setCor(novaProduto.getCor());
		produto.setTipo(novaProduto.getTipo());
		produto.setCusto(novaProduto.getCusto());
		produto.setVenda(novaProduto.getVenda());
		produto.setQuantidadeEstoque(novaProduto.getQuantidadeEstoque());
		produto.setDescricao(novaProduto.getDescricao());
		produto.setAtivo(novaProduto.getAtivo());
		produto.setLoja(novaProduto.getLoja());
		produto.setFornecedor(novaProduto.getFornecedor());

		return produtoRepository.save(produto);
	}

	/**
	 * Lista os produtos que possuem quantidade em estoque maior que zero.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de produtos com estoque.
	 */
	public List<Produto> listarApenasComEstoque(Integer lojaId) {
		return produtoRepository.findByLojaIdAndQuantidadeEstoqueGreaterThan(lojaId, 0);
	}

	/**
	 * Deleta um produto pelo seu ID.
	 * 
	 * @param id O ID do produto a ser deletado.
	 * @throws RuntimeException Se o produto não for encontrado.
	 */
	public void deletarProduto(Integer id) {
		Produto existente = buscarPorId(id);
		produtoRepository.delete(existente);
	}

	/**
	 * Conta o número total de produtos.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return O número total de produtos.
	 */
	public long contarProdutos(Integer lojaId) {
		return produtoRepository.countByLojaId(lojaId);
	}

	/**
	 * Conta o número de produtos que possuem estoque maior que zero.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return O número de produtos com estoque.
	 */
	public long contarProdutosComEstoque(Integer lojaId) {
		return produtoRepository.countByLojaIdAndQuantidadeEstoqueGreaterThan(lojaId, 0);
	}

	/**
	 * Lista os produtos com estoque igual ou menor que o limite fornecido.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @param limite O limite máximo de estoque para ser considerado baixo.
	 * @return Uma lista de produtos com estoque baixo.
	 */
	public List<Produto> listarEstoqueBaixo(Integer lojaId, int limite) {
		return produtoRepository.findByLojaIdAndQuantidadeEstoqueLessThanEqual(lojaId, limite);
	}

	/**
	 * Busca produtos cujo nome, tipo, cor ou tamanho contenha o termo informado.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @param termo  O termo de busca que será comparado com nome, tipo, cor e
	 *               tamanho do produto.
	 * @return Uma lista de produtos que correspondem ao termo de busca.
	 */
	public List<Produto> buscarPorTermo(Integer lojaId, String termo) {
		return produtoRepository.buscarPorTermo(lojaId, termo);
	}

}