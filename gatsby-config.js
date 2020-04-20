module.exports = {
    siteMetadata: {
        title: `Alan Mól`,
        titleTemplate: "% - ",
        siteUrl: `http://alanmol.com.br`,
        url: "http://alanmol.com.br",
        image: "/img/alanmol.jpg",
        description: `Site pessoal de Alan Mól`,
        twitterUsername: "molx",
        type: "website"
    },
    plugins: [
        {
            resolve: `gatsby-plugin-typography`,
            options: {
                pathToConfigModule: `src/utils/typography`,
            },
        },
        {
            resolve: `gatsby-source-filesystem`,
            options: {
                name: `data`,
                path: `${__dirname}/src/data/`,
            },
        },
        `gatsby-transformer-csv`,
        {
            resolve: `gatsby-plugin-google-analytics`,
            options: {
                trackingId: "UA-60942909-1",
            },
        },
        `gatsby-plugin-react-helmet`
    ],
}
