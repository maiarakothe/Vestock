package br.edu.unoesc.vestock.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Condicional;
import br.edu.unoesc.vestock.service.CondicionalService;

@RestController
@RequestMapping("api/condicionais")
public class CondicionalController {

	private final CondicionalService condicionalService;

	public CondicionalController(CondicionalService condicionalService) {
		this.condicionalService = condicionalService;
	}

	@GetMapping
	public ResponseEntity<List<Condicional>> listarTodos() {
		return ResponseEntity.ok(condicionalService.listarTodos());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Condicional> buscarPorId(@PathVariable Integer id) {
		return ResponseEntity.ok(condicionalService.buscarPorId(id));
	}

	@PostMapping
	public ResponseEntity<?> criar(@RequestBody Condicional condicional) {
		try {
			Condicional salvo = condicionalService.criarCondicional(condicional);
			return ResponseEntity.ok(salvo);
		} catch (RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());

		} catch (Exception e) {
			return ResponseEntity.badRequest().body("Erro inesperado: " + e.getMessage());
		}
	}

	@PutMapping("/{id}")
	public ResponseEntity<Condicional> atualizar(@PathVariable Integer id, @RequestBody Condicional nova) {
		return ResponseEntity.ok(condicionalService.atualizarCondicional(id, nova));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		condicionalService.deletarCondicional(id);
		return ResponseEntity.noContent().build();
	}

	@PatchMapping("/{id}/devolver")
	public ResponseEntity<?> devolver(@PathVariable Integer id) {
		try {
			Condicional atualizado = condicionalService.marcarComoDevolvido(id);
			return ResponseEntity.ok(atualizado);
		} catch (RuntimeException e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		} catch (Exception e) {
			return ResponseEntity.status(500).body("Erro ao marcar devolução: " + e.getMessage());
		}
	}

	@GetMapping("/total-ativas")
	public Map<String, Long> getTotalCondicionaisAtivas() {
		long totalAtivas = condicionalService.contarCondicionaisAtivas();
		return Map.of("totalAtivas", totalAtivas);
	}

	@GetMapping("/vencendo-hoje")
	public ResponseEntity<List<Condicional>> getCondicionaisVencendoHoje() {
		List<Condicional> vencendoHoje = condicionalService.listarCondicionaisVencendoHoje();
		return ResponseEntity.ok(vencendoHoje);
	}

}
