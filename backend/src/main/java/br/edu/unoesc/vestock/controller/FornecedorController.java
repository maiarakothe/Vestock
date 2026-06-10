package br.edu.unoesc.vestock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Fornecedor;
import br.edu.unoesc.vestock.service.FornecedorService;

@RestController
@RequestMapping("/api/fornecedores")
public class FornecedorController {

	private final FornecedorService fornecedorService;

	public FornecedorController(FornecedorService fornecedorService) {
		this.fornecedorService = fornecedorService;
	}

	@GetMapping
	public List<Fornecedor> listarTodos() {
		return fornecedorService.listarTodos();
	}

	@GetMapping("/{id}")
	public ResponseEntity<Fornecedor> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(fornecedorService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<Fornecedor> criar(@RequestBody Fornecedor fornecedor) {
		Fornecedor criado = fornecedorService.criarFornecedor(fornecedor);
		return ResponseEntity.status(HttpStatus.CREATED).body(criado);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Fornecedor> atualizar(@PathVariable Integer id, @RequestBody Fornecedor fornecedor) {
		return ResponseEntity.ok(fornecedorService.atualizarFornecedor(id, fornecedor));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		fornecedorService.deletarFornecedor(id);
		return ResponseEntity.noContent().build();
	}
}
