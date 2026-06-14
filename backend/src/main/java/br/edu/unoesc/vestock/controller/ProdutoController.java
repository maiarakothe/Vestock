package br.edu.unoesc.vestock.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Produto;
import br.edu.unoesc.vestock.service.ProdutoService;

@RestController
@RequestMapping("/api/produtos")
public class ProdutoController {

	private final ProdutoService produtoService;

	public ProdutoController(ProdutoService produtoService) {
		this.produtoService = produtoService;
	}

	@GetMapping
	public List<Produto> listarTodos(@RequestHeader("lojaId") Integer lojaId) {
		return produtoService.listarTodos(lojaId);
	}

	@GetMapping("/{id}")
	public ResponseEntity<Produto> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(produtoService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<Produto> criar(@RequestBody Produto produto) {
		Produto criado = produtoService.criarProduto(produto);
		return ResponseEntity.status(HttpStatus.CREATED).body(criado);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Produto> atualizar(@PathVariable Integer id, @RequestBody Produto produto) {
		return ResponseEntity.ok(produtoService.atualizarProduto(id, produto));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		produtoService.deletarProduto(id);
		return ResponseEntity.noContent().build();
	}

	@GetMapping("/com-estoque")
	public List<Produto> listarComEstoque(@RequestHeader("lojaId") Integer lojaId) {
		return produtoService.listarApenasComEstoque(lojaId);
	}

	@GetMapping("/total")
	public Map<String, Object> getTotalEstoque(@RequestHeader("lojaId") Integer lojaId) {
		long totalEstoque = produtoService.contarProdutosComEstoque(lojaId);
		List<Produto> estoqueBaixo = produtoService.listarEstoqueBaixo(lojaId, 5); // limite de baixo estoque = 5

		return Map.of("totalEstoque", totalEstoque, "estoqueBaixo", estoqueBaixo);
	}

	@GetMapping("/search")
	public List<Produto> buscar(
			@RequestHeader("lojaId") Integer lojaId,
			@RequestParam("q") String termo) {
		return produtoService.buscarPorTermo(lojaId, termo);
	}
}
