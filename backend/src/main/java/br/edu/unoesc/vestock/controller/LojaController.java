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

import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.service.LojaService;

@RestController
@RequestMapping("/api/lojas")
public class LojaController {

	private final LojaService lojaService;

	public LojaController(LojaService lojaService) {
		this.lojaService = lojaService;
	}

	@GetMapping
	public List<Loja> listarTodos() {
		return lojaService.listarTodos();
	}

	@GetMapping("/{id}")
	public ResponseEntity<Loja> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(lojaService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<Loja> criar(@RequestBody Loja loja) {
		Loja criada = lojaService.criarLoja(loja);
		return ResponseEntity.status(HttpStatus.CREATED).body(criada);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Loja> atualizar(@PathVariable Integer id, @RequestBody Loja loja) {
		return ResponseEntity.ok(lojaService.atualizarLoja(id, loja));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		lojaService.deletarLoja(id);
		return ResponseEntity.noContent().build();
	}

}