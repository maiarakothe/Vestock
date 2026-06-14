package br.edu.unoesc.vestock.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import br.edu.unoesc.vestock.model.Desconto;
import br.edu.unoesc.vestock.model.Loja;
import br.edu.unoesc.vestock.repository.DescontoRepository;
import br.edu.unoesc.vestock.repository.LojaRepository;

@Service
public class DescontoService {

	private final DescontoRepository descontoRepository;
	private final LojaRepository lojaRepository;

	public DescontoService(DescontoRepository descontoRepository, LojaRepository lojaRepository) {
		this.descontoRepository = descontoRepository;
		this.lojaRepository = lojaRepository;
	}

	/**
	 * Lista todos os descontos.
	 * 
	 * @param lojaId O ID da loja logada.
	 * @return Uma lista de todos os descontos.
	 */
	public List<Desconto> listarTodos(Integer lojaId) {
		return descontoRepository.findByLojaId(lojaId);
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
		if (desconto.getLoja() == null || desconto.getLoja().getId() == null) {
			throw new RuntimeException("Loja é obrigatória para cadastrar um desconto");
		}

		Loja loja = lojaRepository.findById(desconto.getLoja().getId())
				.orElseThrow(() -> new RuntimeException("Loja não encontrada"));

		desconto.setLoja(loja);
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