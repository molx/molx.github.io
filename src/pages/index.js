import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import Projlink from "../components/projlink"

export default ({ data }) => {
    return (
        <Layout>
            <h2>Sobre</h2>
            <img
                alt="Foto de Alan Mól"
                src={"img/alanmol.jpg"}
                style={{ float: "right", width: "15%", marginLeft: "2%" }}
            />
            <p>
                Me formei em Química pela Universidade de Brasília em 2010, e em 2015 concluí meu mestrado em Química
                Analítica. Além disso, desde 2013 sou servidor público também da Universidade de Brasília, trabalhando
                como Químico. Entre 2013 e 2015, trabalhei no laboratório de Química do Solo da Faculdade de Agronomia e
                Medicina Veterinária e desde 2016 estou na Central Analítica do Instituto de Química, onde trabalho
                principalmente com cromatografia e espetrometria de massas.
            </p>
            <br />
            {data.allPerfisCsv.nodes.map(proj => (
                <Projlink data={proj} />
            ))}
            <hr />
        </Layout>
    )
}

export const query = graphql`
    query {
        allPerfisCsv {
            nodes {
                img
                name
                url
                desc
            }
        }
    }
`
