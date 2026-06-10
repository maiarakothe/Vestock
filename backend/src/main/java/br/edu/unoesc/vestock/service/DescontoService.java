package br.edu.unoesc.vestock.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Desconto;
import br.edu.unoesc.vestock.repository.DescontoRepository;

@Service
public class DescontoService {

	private final DescontoRepository descontoRepository;

	public DescontoService(DescontoRepository descontoRepository) {
		this.descontoRepository = descontoRepository;
	}

	/**
	 * Lista todos os descontos.
	 * 
	 * @return Uma lista de todos os descontos.
	 */
	public List<Desconto> listarTodos() {
		return descontoRepository.findAll();
	}

	/**
	 * Busca um desconto pelo seu ID.
	 * 
	 * @param id O ID do desconto a ser buscado.
	 * @return O desconto encontrado.
	 * @throws RuntimeException Se o desconto não for encontrado.
	 */
	public Desconto buscarPorId(Integer id) {
		Optional<Desconto> desconto = descontoRepository.findById(id);

		if (desconto.isPresent()) {
			return desconto.get();
		} else {
			throw new RuntimeException("Desconto não encontrado: " + id);
		}
	}

	/**
	 * Cria um novo desconto, definindo a data de cadastro para o momento atual.
	 * 
	 * @param desconto O desconto a ser criado.
	 * @return O desconto salvo.
	 */
	public Desconto criarDesconto(Desconto desconto) {
		desconto.setDataCadastro(LocalDateTime.now());
		return descontoRepository.save(desconto);
	}

	/**
	 * Atualiza um desconto existente com novos dados.
	 * 
	 * @param id   O ID do desconto a ser atualizado.
	 * @param novo O objeto desconto com os novos dados.
	 * @return O desconto atualizado.
	 * @throws RuntimeException Se o desconto não for encontrado.
	 */
	public Desconto atualizarDesconto(Integer id, Desconto novo) {
		Desconto desconto = buscarPorId(id);

		desconto.setNome(novo.getNome());
		desconto.setValor(novo.getValor());
		desconto.setDataValidade(novo.getDataValidade());
		desconto.setVenda(novo.getVenda());

		return descontoRepository.save(desconto);
	}

	/**
	 * Deleta um desconto pelo seu ID.
	 * 
	 * @param id O ID do desconto a ser deletado.
	 * @throws RuntimeException Se o desconto não for encontrado.
	 */
	public void deletarDesconto(Integer id) {
		if (!descontoRepository.existsById(id)) {
			throw new RuntimeException("Desconto não encontrado: " + id);
		}
		descontoRepository.deleteById(id);
	}
}