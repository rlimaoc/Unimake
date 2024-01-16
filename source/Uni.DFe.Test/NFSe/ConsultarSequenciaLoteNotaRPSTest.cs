﻿using System.Collections.Generic;
using System.IO;
using System.Xml;
using Uni.Business.DFe.Servicos;
using Uni.Business.DFe.Servicos.NFSe;
using Xunit;

namespace Uni.DFe.Test.NFSe
{
    /// <summary>
    /// Testar o serviço: ConsultarDadosCadastrais
    /// </summary>
    public class ConsultarSequenciaLoteNotaRPSTest
    {
        /// <summary>
        /// Monta o parâmetros, de forma dinâmica, para o cenário de testes
        /// </summary>
        public static IEnumerable<object[]> Parametros => TestUtility.PreparaDadosCenario("ConsultarSequenciaLoteNotaRPS");

        /// <summary>
        /// Consulta dados cadastrais para saber se a conexão com o webservice está ocorrendo corretamente.
        /// </summary>
        /// <param name="tipoAmbiente">Ambiente para onde deve ser enviado o XML</param>
        [Theory]
        [Trait("DFe", "NFSe")]
        [MemberData(nameof(Parametros))]
        public void ConsultarSequenciaLoteNotaRPS(TipoAmbiente tipoAmbiente, PadraoNFSe padraoNFSe, string versaoSchema, int codMunicipio)
        {
            var nomeXMLEnvio = "ConsultaSequenciaLoteNotaRPS-ped-seqlotenotarps.xml";
            var arqXML = "..\\..\\..\\NFSe\\Resources\\" + padraoNFSe.ToString() + "\\" + versaoSchema + "\\" + nomeXMLEnvio;

            Assert.True(File.Exists(arqXML), "Arquivo " + arqXML + " não foi localizado.");

            var conteudoXML = new XmlDocument();
            conteudoXML.Load(arqXML);

            var configuracao = new Configuracao
            {
                TipoDFe = TipoDFe.NFSe,
                CertificadoDigital = PropConfig.CertificadoDigital,
                TipoAmbiente = tipoAmbiente,
                CodigoMunicipio = codMunicipio,
                Servico = Servico.NFSeConsultarSequenciaLoteNotaRPS,
                SchemaVersao = versaoSchema,
                MunicipioToken = "99n0556af8e4218e05b88e266fhca55be17b14a4495c269d1db0af57f925f04e77c38f9870842g5g60b6827a9fje8ec9" //Tem município que exige token, então já vamos deixar algo definido para que utilize nos padrões necessários durante o teste unitário. Não é obrigatório para todos os padrões e será utilizado somente nos que solicitam.
            };

            var consultarSequenciaLoteNotaRPS = new ConsultarSequenciaLoteNotaRPS(conteudoXML, configuracao);
            consultarSequenciaLoteNotaRPS.Executar();
        }
    }
}