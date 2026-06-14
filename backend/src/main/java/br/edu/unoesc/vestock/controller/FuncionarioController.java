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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.unoesc.vestock.model.Funcionario;
import br.edu.unoesc.vestock.service.FuncionarioService;

@RestController
@RequestMapping("/api/funcionarios")
public class FuncionarioController {

	private final FuncionarioService funcionarioService;

	public FuncionarioController(FuncionarioService funcionarioService) {
		this.funcionarioService = funcionarioService;
	}

	@GetMapping
	public List<Funcionario> listarTodos(@RequestHeader("lojaId") Integer lojaId) {
		return funcionarioService.listarTodos(lojaId);
	}

	@GetMapping("/{id}")
	public ResponseEntity<Funcionario> buscarPorId(@PathVariable Integer id) {
		try {
			return ResponseEntity.ok(funcionarioService.buscarPorId(id));
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}

	@PostMapping
	public ResponseEntity<Funcionario> criar(@RequestBody Funcionario funcionario) {
		Funcionario criado = funcionarioService.criarFuncionario(funcionario);
		return ResponseEntity.status(HttpStatus.CREATED).body(criado);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Funcionario> atualizar(@PathVariable Integer id, @RequestBody Funcionario funcionario) {
		return ResponseEntity.ok(funcionarioService.atualizarFuncionario(id, funcionario));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Integer id) {
		funcionarioService.deletarFuncionario(id);
		return ResponseEntity.noContent().build();
	}
}
