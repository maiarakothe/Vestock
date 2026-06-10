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

import br.edu.unoesc.vestock.model.ItemVenda;
import br.edu.unoesc.vestock.service.ItemVendaService;

@RestController
@RequestMapping("/api/itens-venda")
public class ItemVendaController {

	private final ItemVendaService itemVendaService;

	public ItemVendaController(ItemVendaService itemVendaService) {
		this.itemVendaService = itemVendaService;
	}

	@GetMapping
	public List<ItemVenda> listarTodos() {
		return itemVendaService.listarTodos();
	}

	@GetMapping("/{id}")
	public ResponseEntity<ItemVenda> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(itemVendaService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<ItemVenda> criar(@RequestBody ItemVenda item) {
		ItemVenda criado = itemVendaService.criarItemVenda(item);
		return ResponseEntity.status(HttpStatus.CREATED).body(criado);
	}

	@PutMapping("/{id}")
	public ResponseEntity<ItemVenda> atualizar(@PathVariable Integer id, @RequestBody ItemVenda item) {

		return ResponseEntity.ok(itemVendaService.atualizarItemVenda(id, item));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		itemVendaService.deletarItemVenda(id);
		return ResponseEntity.noContent().build();
	}
}
