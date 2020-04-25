import React from "react"
import { Link, graphql } from "gatsby"
import Layout from "../components/layout"
import SEO from "../components/SEO"

export default ({ data }) => {
    return (
        <div>
            <Layout>
                <SEO title={"Blog"} />
                <h2>Últimos posts</h2>
                {data.allMarkdownRemark.edges.map(({ node }) => (
                    <div key={node.id}>
                        <Link to={`/blog/` + node.frontmatter.slug}>
                            <h4>
                                {node.frontmatter.title} <span>— {node.frontmatter.date}</span>
                            </h4>
                            <p>{node.excerpt}</p>
                        </Link>
                    </div>
                ))}
            </Layout>
        </div>
    )
}

export const query = graphql`
    query {
        allMarkdownRemark(sort: { fields: [frontmatter___date], order: DESC }) {
            totalCount
            edges {
                node {
                    id
                    frontmatter {
                        slug
                        title
                        date(formatString: "DD/MM/YYYY")
                    }
                    fields {
                        slug
                    }
                    excerpt
                }
            }
        }
    }
`
