import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import Projlink from "../components/projlink"

export default ({ data }) => {
    return (
        <div>
            <Layout>
                <h2>Projetos</h2>
                <p>
                    Sempre gostei de me aventurar no mundo da computação, e aos trancos e barrancos fui aprendendo
                    algumas coisas sobre desenvolvimento. Nesse site, além dos links para meu currículo e alguns perfis,
                    você vai encontrar também alguns projetos que desenvolvi ao longo destes anos.
                </p>
                {data.allProjetosCsv.nodes.map(proj => (
                    <Projlink data={proj} />
                ))}
                <hr />
            </Layout>
        </div>
    )
}

export const query = graphql`
    query {
        allProjetosCsv {
            nodes {
                img
                name
                url
                desc
            }
        }
    }
`
