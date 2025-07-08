//  APOLLO SERVER CON APM Y MONITORING COMPLETO
import apm from 'elastic-apm-node';

//  Inicializar APM antes que cualquier otro import
const apmAgent = apm.start({
  serviceName: 'apollo-fintech-server',
  serverUrl: process.env.ELASTIC_APM_SERVER_URL || 'http://10.0.1.200:8200',
  environment: process.env.NODE_ENV || 'production',
  captureBody: 'all',
  captureHeaders: true,
  logLevel: 'info',
  metricsInterval: '10s',
  transactionSampleRate: 1.0, // 100% sampling para desarrollo
  centralConfig: false,
  breakdownMetrics: true,
  captureSpanStackTraces: true
});

import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import winston from 'winston';
import { ElasticsearchTransport } from 'winston-elasticsearch';

//  Configurar logging estructurado
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { 
    service: 'apollo-fintech-server',
    environment: process.env.NODE_ENV || 'production'
  },
  transports: [
    new winston.transports.File({ 
      filename: '/home/ubuntu/app/logs/error.log', 
      level: 'error' 
    }),
    new winston.transports.File({ 
      filename: '/home/ubuntu/app/logs/combined.log' 
    }),
    new winston.transports.Console({
      format: winston.format.simple()
    }),
    //  Enviar logs directamente a Elasticsearch
    new ElasticsearchTransport({
      level: 'info',
      clientOpts: {
        node: process.env.ELASTICSEARCH_URL || 'http://10.0.1.200:9200'
      },
      index: 'apollo-logs'
    })
  ]
});

// 🏦 GraphQL Schema para FinTech Solutions
const typeDefs = `#graphql
    """
    Representación de un instrumento financiero
    """
    type FinancialInstrument {
        id: ID!
        symbol: String!
        name: String!
        currentPrice: Float!
        currency: String!
        lastUpdate: String!
        marketCap: Float
        volume24h: Float
        change24h: Float
    }

    """
    Datos de portafolio de usuario
    """
    type Portfolio {
        id: ID!
        userId: String!
        totalValue: Float!
        instruments: [FinancialInstrument!]!
        lastUpdate: String!
    }

    """
    Transacción financiera
    """
    type Transaction {
        id: ID!
        userId: String!
        instrumentId: String!
        type: TransactionType!
        amount: Float!
        price: Float!
        timestamp: String!
        status: TransactionStatus!
    }

    enum TransactionType {
        BUY
        SELL
    }

    enum TransactionStatus {
        PENDING
        COMPLETED
        FAILED
        CANCELLED
    }

    """
    Queries disponibles para clientes FinTech
    """
    type Query {
        """
        Obtener instrumentos financieros disponibles
        """
        instruments: [FinancialInstrument!]!
        
        """
        Obtener instrumento específico por símbolo
        """
        instrument(symbol: String!): FinancialInstrument
        
        """
        Obtener portafolio de usuario
        """
        portfolio(userId: String!): Portfolio
        
        """
        Obtener transacciones de usuario
        """
        transactions(userId: String!, limit: Int = 10): [Transaction!]!
        
        """
        Health check del servicio
        """
        health: String!
    }

    """
    Mutaciones para operaciones financieras
    """
    type Mutation {
        """
        Crear nueva transacción
        """
        createTransaction(
            userId: String!
            instrumentId: String!
            type: TransactionType!
            amount: Float!
        ): Transaction!
    }
`;

//  Datos de ejemplo para FinTech Solutions
const instruments = [
  {
    id: "1",
    symbol: "AAPL",
    name: "Apple Inc.",
    currentPrice: 182.52,
    currency: "USD",
    lastUpdate: new Date().toISOString(),
    marketCap: 2847000000000,
    volume24h: 48293756,
    change24h: 1.24
  },
  {
    id: "2",
    symbol: "GOOGL",
    name: "Alphabet Inc.",
    currentPrice: 138.45,
    currency: "USD",
    lastUpdate: new Date().toISOString(),
    marketCap: 1765000000000,
    volume24h: 23847391,
    change24h: -0.87
  },
  {
    id: "3",
    symbol: "BTC-USD",
    name: "Bitcoin",
    currentPrice: 43250.75,
    currency: "USD",
    lastUpdate: new Date().toISOString(),
    marketCap: 847000000000,
    volume24h: 18475839201,
    change24h: 3.45
  },
  {
    id: "4",
    symbol: "ETH-USD",
    name: "Ethereum",
    currentPrice: 2648.32,
    currency: "USD",
    lastUpdate: new Date().toISOString(),
    marketCap: 318000000000,
    volume24h: 9384756291,
    change24h: 2.18
  }
];

const portfolios = [
  {
    id: "p1",
    userId: "user123",
    totalValue: 125000.00,
    instruments: instruments.slice(0, 3),
    lastUpdate: new Date().toISOString()
  }
];

const transactions = [
  {
    id: "t1",
    userId: "user123",
    instrumentId: "1",
    type: "BUY",
    amount: 10,
    price: 180.25,
    timestamp: new Date(Date.now() - 86400000).toISOString(),
    status: "COMPLETED"
  },
  {
    id: "t2",
    userId: "user123",
    instrumentId: "3",
    type: "BUY",
    amount: 0.5,
    price: 42800.00,
    timestamp: new Date(Date.now() - 43200000).toISOString(),
    status: "COMPLETED"
  }
];

//  Resolvers con APM tracing y logging
const resolvers = {
  Query: {
    instruments: async () => {
      const span = apmAgent.startSpan('query.instruments');
      try {
        logger.info('Fetching all financial instruments');
        
        // Simular latencia de base de datos
        await new Promise(resolve => setTimeout(resolve, Math.random() * 100));
        
        span?.setLabel('instrument_count', instruments.length);
        return instruments;
      } catch (error) {
        apmAgent.captureError(error);
        logger.error('Error fetching instruments', { error });
        throw error;
      } finally {
        span?.end();
      }
    },

    instrument: async (_, { symbol }) => {
      const span = apmAgent.startSpan('query.instrument');
      try {
        logger.info('Fetching instrument by symbol', { symbol });
        
        // Simular query a base de datos
        await new Promise(resolve => setTimeout(resolve, Math.random() * 50));
        
        const instrument = instruments.find(i => i.symbol === symbol);
        if (!instrument) {
          logger.warn('Instrument not found', { symbol });
          return null;
        }
        
        span?.setLabel('symbol', symbol);
        span?.setLabel('found', true);
        return instrument;
      } catch (error) {
        apmAgent.captureError(error);
        logger.error('Error fetching instrument', { symbol, error });
        throw error;
      } finally {
        span?.end();
      }
    },

    portfolio: async (_, { userId }) => {
      const span = apmAgent.startSpan('query.portfolio');
      try {
        logger.info('Fetching user portfolio', { userId });
        
        // Simular latencia de cálculo de portafolio
        await new Promise(resolve => setTimeout(resolve, Math.random() * 200));
        
        const portfolio = portfolios.find(p => p.userId === userId);
        if (!portfolio) {
          logger.warn('Portfolio not found', { userId });
          return null;
        }
        
        span?.setLabel('userId', userId);
        span?.setLabel('totalValue', portfolio.totalValue);
        return portfolio;
      } catch (error) {
        apmAgent.captureError(error);
        logger.error('Error fetching portfolio', { userId, error });
        throw error;
      } finally {
        span?.end();
      }
    },

    transactions: async (_, { userId, limit }) => {
      const span = apmAgent.startSpan('query.transactions');
      try {
        logger.info('Fetching user transactions', { userId, limit });
        
        // Simular query a base de datos
        await new Promise(resolve => setTimeout(resolve, Math.random() * 150));
        
        const userTransactions = transactions
          .filter(t => t.userId === userId)
          .slice(0, limit);
        
        span?.setLabel('userId', userId);
        span?.setLabel('limit', limit);
        span?.setLabel('result_count', userTransactions.length);
        
        return userTransactions;
      } catch (error) {
        apmAgent.captureError(error);
        logger.error('Error fetching transactions', { userId, limit, error });
        throw error;
      } finally {
        span?.end();
      }
    },

    health: () => {
      logger.info('Health check requested');
      return `Apollo FinTech Server is healthy! 🏦 Time: ${new Date().toISOString()}`;
    }
  },

  Mutation: {
    createTransaction: async (_, { userId, instrumentId, type, amount }) => {
      const span = apmAgent.startSpan('mutation.createTransaction');
      try {
        logger.info('Creating new transaction', { userId, instrumentId, type, amount });
        
        // Simular validaciones y procesamiento
        await new Promise(resolve => setTimeout(resolve, Math.random() * 300));
        
        const instrument = instruments.find(i => i.id === instrumentId);
        if (!instrument) {
          const error = new Error('Instrument not found');
          logger.error('Transaction failed - instrument not found', { instrumentId });
          throw error;
        }
        
        const newTransaction = {
          id: `t${Date.now()}`,
          userId,
          instrumentId,
          type,
          amount,
          price: instrument.currentPrice,
          timestamp: new Date().toISOString(),
          status: "PENDING"
        };
        
        transactions.push(newTransaction);
        
        span?.setLabel('userId', userId);
        span?.setLabel('instrumentId', instrumentId);
        span?.setLabel('type', type);
        span?.setLabel('amount', amount);
        
        logger.info('Transaction created successfully', { 
          transactionId: newTransaction.id,
          userId,
          instrumentId,
          type,
          amount 
        });
        
        return newTransaction;
      } catch (error) {
        apmAgent.captureError(error);
        logger.error('Error creating transaction', { userId, instrumentId, type, amount, error });
        throw error;
      } finally {
        span?.end();
      }
    }
  }
};

//  Inicializar Apollo Server
const server = new ApolloServer({
  typeDefs,
  resolvers,
  //  Integración con APM para tracing automático
  plugins: [
    {
      async requestDidStart() {
        return {
          didResolveOperation(requestContext) {
            const operationName = requestContext.request.operationName || 'anonymous';
            const operationType = requestContext.operationName || 'unknown';
            
            // Crear span personalizado para cada operación GraphQL
            const span = apmAgent.startSpan(`graphql.${operationType}.${operationName}`);
            if (span) {
              span.setLabel('operation_name', operationName);
              span.setLabel('operation_type', operationType);
            }
            
            logger.info('GraphQL operation started', { 
              operationName, 
              operationType,
              query: requestContext.request.query 
            });
          },
          
          didEncounterErrors(requestContext) {
            const errors = requestContext.errors;
            errors?.forEach(error => {
              apmAgent.captureError(error);
              logger.error('GraphQL execution error', { 
                error: error.message,
                locations: error.locations,
                path: error.path 
              });
            });
          }
        };
      }
    }
  ],
  introspection: true, //  Habilitado para desarrollo
  includeStacktraceInErrorResponses: true
});

//  Crear directorio de logs
import { mkdir } from 'fs/promises';
try {
  await mkdir('/home/ubuntu/app/logs', { recursive: true });
} catch (error) {
  console.log('Logs directory already exists or created');
}

//  Iniciar servidor
const { url } = await startStandaloneServer(server, {
  listen: { port: 4000, host: '0.0.0.0' },
  context: async ({ req }) => {
    //  Agregar contexto de APM a cada request
    const traceId = apmAgent.currentTraceparent;
    return {
      traceId,
      userAgent: req.headers['user-agent'],
      ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress
    };
  }
});

logger.info(' Apollo FinTech Server ready!', { 
  url,
  environment: process.env.NODE_ENV || 'production',
  apmEnabled: !!apmAgent,
  timestamp: new Date().toISOString()
});

console.log(`🏦 Apollo FinTech Server ready at: ${url}`);
console.log(` APM Monitoring: ${apmAgent ? ' Enabled' : ' Disabled'}`);
console.log(` GraphQL Playground: ${url}graphql`);
