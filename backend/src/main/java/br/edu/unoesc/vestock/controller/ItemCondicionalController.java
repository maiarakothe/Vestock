package br.edu.unoesc.vestock.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.ItemCondicional;
import br.edu.unoesc.vestock.service.ItemCondicionalService;

@RestController
@RequestMapping("api/itens-condicional")
public class ItemCondicionalController {

	private final ItemCondicionalService itemService;

	public ItemCondicionalController(ItemCondicionalService itemService) {
		this.itemService = itemService;
	}

	@GetMapping
	public ResponseEntity<List<ItemCondicional>> listarTodos() {
		return ResponseEntity.ok(itemService.listarTodos());
	}

	@GetMapping("/{id}")
	public ResponseEntity<ItemCondicional> buscarPorId(@PathVariable Integer id) {
		return ResponseEntity.ok(itemService.buscarPorId(id));
	}

	@PostMapping
	public ResponseEntity<ItemCondicional> criar(@RequestBody ItemCondicional item) {
		return ResponseEntity.status(201).body(itemService.criarItem(item));
	}

	@PutMapping("/{id}")
	public ResponseEntity<ItemCondicional> atualizar(@PathVariable Integer id, @RequestBody ItemCondicional novoItem) {
		return ResponseEntity.ok(itemService.atualizarItem(id, novoItem));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		itemService.deletarItem(id);
		return ResponseEntity.noContent().build();
	}
}
