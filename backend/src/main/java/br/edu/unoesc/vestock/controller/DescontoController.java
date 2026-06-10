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

import br.edu.unoesc.vestock.model.Desconto;
import br.edu.unoesc.vestock.service.DescontoService;

@RestController
@RequestMapping("/api/descontos")
public class DescontoController {

    private final DescontoService descontoService;

    public DescontoController(DescontoService descontoService) {
        this.descontoService = descontoService;
    }

    @GetMapping
    public List<Desconto> listarTodos() {
        return descontoService.listarTodos();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Desconto> buscarPorId(@PathVariable Integer id) {
        try {
            return ResponseEntity.ok(descontoService.buscarPorId(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<Desconto> criar(@RequestBody Desconto desconto) {
        Desconto criado = descontoService.criarDesconto(desconto);
        return ResponseEntity.status(HttpStatus.CREATED).body(criado);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Desconto> atualizar(
            @PathVariable Integer id,
            @RequestBody Desconto desconto) {

        return ResponseEntity.ok(descontoService.atualizarDesconto(id, desconto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Integer id) {
        descontoService.deletarDesconto(id);
        return ResponseEntity.noContent().build();
    }
}
