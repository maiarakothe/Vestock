package br.edu.unoesc.vestock.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Venda;
import br.edu.unoesc.vestock.service.VendaService;

@RestController
@RequestMapping("/api/vendas")
public class VendaController {

	private final VendaService vendaService;

	public VendaController(VendaService vendaService) {
		this.vendaService = vendaService;
	}

	@GetMapping
	public List<Venda> listarTodos(@RequestHeader("lojaId") Integer lojaId) {
		return vendaService.listarTodos(lojaId);
	}

	@GetMapping("/{id}")
	public ResponseEntity<Venda> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(vendaService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<Venda> criar(@RequestBody Venda venda) {
		Venda criada = vendaService.criarVenda(venda);
		return ResponseEntity.status(HttpStatus.CREATED).body(criada);
	}

	// Procedure das vendas com descontos
	@GetMapping("/desconto")
	public BigDecimal aplicarDesconto(@RequestParam BigDecimal total, @RequestParam BigDecimal desconto) {

		return vendaService.calcularDesconto(total, desconto);
	}

}
