package br.edu.unoesc.vestock.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Cliente;
import br.edu.unoesc.vestock.service.ClienteService;

@RestController
@RequestMapping("/api/clientes")
public class ClienteController {

	private final ClienteService clienteService;

	public ClienteController(ClienteService clienteService) {
		this.clienteService = clienteService;
	}

	@GetMapping
	public ResponseEntity<List<Cliente>> listar(
			@RequestHeader("lojaId") Integer lojaId,
			@RequestParam(value = "search", required = false) String search) {
		return ResponseEntity.ok(clienteService.buscar(lojaId, search));
	}

	@GetMapping("/{id}")
	public Cliente buscarPorId(@PathVariable Integer id) {
		return clienteService.buscarPorId(id);
	}

	@PostMapping
	public Cliente criar(@RequestBody Cliente cliente) {
		return clienteService.criarCliente(cliente);
	}

	@PutMapping("/{id}")
	public Cliente atualizar(@PathVariable Integer id, @RequestBody Cliente cliente) {
		return clienteService.atualizarCliente(id, cliente);
	}

	@DeleteMapping("/{id}")
	public void deletar(@PathVariable Integer id) {
		clienteService.deletarCliente(id);
	}

	@GetMapping("/total")
	public Map<String, Long> getTotalClientes(@RequestHeader("lojaId") Integer lojaId) {
		long total = clienteService.contarClientes(lojaId);
		return Map.of("totalClientes", total);
	}
}
