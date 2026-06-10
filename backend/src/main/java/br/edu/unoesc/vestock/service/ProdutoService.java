package br.edu.unoesc.vestock.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.repository.ProdutoRepository;

@Service
public class ProdutoService {

	private final ProdutoRepository produtoRepository;

	public ProdutoService(ProdutoRepository produtoRepository) {
		this.produtoRepository = produtoRepository;
	}

	/**
	 * Lista todos os produtos.
	 * 
	 * @return Uma lista de todos os produtos.
	 */
	public List<Produto> listarTodos() {
		return produtoRepository.findAll();
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
	 * @return Uma lista de produtos com estoque.
	 */
	public List<Produto> listarApenasComEstoque() {
		return produtoRepository.findByQuantidadeEstoqueGreaterThan(0);
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
	 * @return O número total de produtos.
	 */
	public long contarProdutos() {
		return produtoRepository.count();
	}

	/**
	 * Conta o número de produtos que possuem estoque maior que zero.
	 * 
	 * @return O número de produtos com estoque.
	 */
	public long contarProdutosComEstoque() {
		return produtoRepository.countByQuantidadeEstoqueGreaterThan(0);
	}

	/**
	 * Lista os produtos com estoque igual ou menor que o limite fornecido.
	 * 
	 * @param limite O limite máximo de estoque para ser considerado baixo.
	 * @return Uma lista de produtos com estoque baixo.
	 */
	public List<Produto> listarEstoqueBaixo(int limite) {
		return produtoRepository.findByQuantidadeEstoqueLessThanEqual(limite);
	}

	/**
	 * Busca produtos cujo nome, tipo, cor ou tamanho contenha o termo informado.
	 * 
	 * @param termo O termo de busca que será comparado com nome, tipo, cor e
	 *              tamanho do produto.
	 * @return Uma lista de produtos que correspondem ao termo de busca.
	 */
	public List<Produto> buscarPorTermo(String termo) {
		return produtoRepository
				.findByNomeContainingIgnoreCaseOrTipoContainingIgnoreCaseOrCorContainingIgnoreCaseOrTamanhoContainingIgnoreCase(
						termo, termo, termo, termo);
	}

}